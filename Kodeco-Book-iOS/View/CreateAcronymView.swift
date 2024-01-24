//
//  CreateAcronymView.swift
//  Kodeco-Book-iOS
//
//  Created by Raphaël Payet on 24/01/2024.
//

import SwiftUI

struct CreateAcronymView: View {
    @Binding var showCreateView: Bool
    
    @State private var short = ""
    @State private var long = ""
    @State private var users: [User] = []
    @State private var selectedUser: User?
    
    var body: some View {
        Form {
            TextField("Short", text: $short)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.words)
            
            TextField("Long", text: $long)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
            
            ForEach(users) { user in
                RadioButton(user: user, selectedUser: $selectedUser)
            }
            
            Button {
                Task { try await save() }
            } label: {
                Text("Save")
            }
        }
        .onAppear {
            Task { try await fetchUsers() }
        }
    }
    
    func fetchUsers() async throws {
        let request = ResourceRequest<User>(resourcePath: "users")
        let resources = try await request.getAll()
        DispatchQueue.main.async {
            self.users = resources
        }
    }
    
    func save() async throws {
        guard !short.isEmpty, !long.isEmpty,
              let userID = selectedUser?.id else { return }
        let request = ResourceRequest<Acronym>(resourcePath: "acronyms")
        let acronym = Acronym(short: short, long: long, userID: userID)
        let acronymData = acronym.toCreateData()
        let createdResource = try await request.save(acronymData)
        if createdResource != nil { showCreateView = false }
    }
}

struct RadioButton: View {
    var user: User
    @Binding var selectedUser: User?
    
    var body: some View {
        Button {
            selectedUser = user
        } label: {
            HStack {
                let isSelected = selectedUser?.id == user.id
                Text(user.name)
                Spacer()
                Image(systemName: isSelected ? "checkmark.circle" : "circle")
            }
        }

    }
}
