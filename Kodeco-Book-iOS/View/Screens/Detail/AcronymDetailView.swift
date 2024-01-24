//
//  AcronymDetailView.swift
//  Kodeco-Book-iOS
//
//  Created by Raphaël Payet on 24/01/2024.
//

import SwiftUI

struct AcronymDetailView: View {
    @Environment(\.dismiss) var dismiss
    
    var acronym: Acronym
    
    @State private var user: User?
    @State private var categories: [Category]?
    @State private var isEditing = false
    @State private var short = ""
    @State private var long = ""
    @State private var userName = ""
    
    var body: some View {
        VStack {
            if isEditing {
                editingView
            } else {
                staticView
            }
        }
        .toolbar {
            ToolbarItem {
                Button {
                    Task { try await editButtonTapped() }
                } label: {
                    Text(isEditing ? "Save" : "Edit")
                }
            }
        }
        .onAppear {
            Task {
                try await fetchData()
            }
        }
    }
    
    var staticView: some View {
        Form {
            Section("Acronym") {
                VStack(alignment: .leading) {
                    Text(acronym.short)
                        .font(.system(size: 18, weight: .bold))
                    
                    Text(acronym.long)
                        .font(.system(size: 15))
                }
            }
            
            Section("User") {
                Text(user?.name ?? "")
            }
            
            if let categories = categories {
                Section("Categories") {
                    ForEach(categories) { category in
                        Text(category.name)
                    }
                }
            }
        }
    }
    
    var editingView: some View {
        Form {
            Section("Acronym") {
                VStack(alignment: .leading) {
                    TextField("Short", text: $short)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                    
                    TextField("Long", text: $long)
                        .autocorrectionDisabled()
                }
            }
            
            Section("User") {
                TextField("Name", text: $userName)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.words)
            }
            
            if let categories = categories {
                Section("Categories") {
                    ForEach(categories) { category in
                        Text(category.name)
                    }
                }
            }
        }
    }
    
    func fetchData() async throws {
        guard let acronymID = acronym.id else { return }
        let request = AcronymRequest(acronymID: acronymID)
        let receivedUser = try await request.getUser()
        let receivedCategories = try await request.getCategories()
        DispatchQueue.main.async {
            self.user = receivedUser
            self.categories = receivedCategories
            syncAcronymWithStates(self.acronym)
        }
    }
    
    func syncAcronymWithStates(_ acronym: Acronym) {
        print(acronym.long, acronym.short)
        self.short = acronym.short
        self.long = acronym.long
        self.userName = user?.name ?? ""
    }
    
    func editButtonTapped() async throws {
        if !isEditing {
            // Update the acronym
            guard let acronymID = acronym.id,
                  let userID = user?.id else { return }
            let request = AcronymRequest(acronymID: acronymID)
            let acronym = Acronym(short: short, long: long, userID: userID)
            let data = acronym.toCreateData()
            let _ = try await request.update(with: data)
        }
    }
}
