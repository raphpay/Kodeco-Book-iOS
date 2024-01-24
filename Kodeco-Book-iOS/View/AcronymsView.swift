//
//  AcronymsView.swift
//  Kodeco-Book-iOS
//
//  Created by Raphaël Payet on 24/01/2024.
//

import SwiftUI

struct Acronym: Identifiable, Codable {
    var id: UUID?
    var short: String
    var long: String
}

struct AcronymsView: View {
    @State private var acronyms: [Acronym] = []
    
    var body: some View {
        NavigationStack {
            if acronyms.isEmpty {
                ContentUnavailableView("No acronyms yet", systemImage: "character.magnify", description: Text("Create one over here"))
            } else {
                List {
                    ForEach(acronyms) { acronym in
                        VStack(alignment: .leading) {
                            Text(acronym.short)
                                .font(.system(size: 18))
                                .bold()
                            Text(acronym.long)
                                .font(.system(size: 15))
                        }
                    }
                }
            }
        }
        .onAppear {
            Task { try await fetchAcronyms() }
        }
    }
    
    func fetchAcronyms() async throws {
        let request = ResourceRequest<Acronym>(resourcePath: "acronyms")
        let resources = try await request.getAll()
        DispatchQueue.main.async {
            self.acronyms = resources
        }

    }
}

#Preview {
    AcronymsView()
}
