//
//  CreateUserView.swift
//  Kodeco-Book-iOS
//
//  Created by Raphaël Payet on 24/01/2024.
//

import SwiftUI

struct CreateUserView: View {
    @State private var name = ""
    @State private var username = ""
    @Binding var showCreateView: Bool
    
    var body: some View {
        Form {
            TextField("Name", text: $name)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.words)
            
            TextField("Username", text: $username)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
            
            Button {
                Task { try await save() }
            } label: {
                Text("Save")
            }
        }
    }
    
    func save() async throws {
        let request = ResourceRequest<User>(resourcePath: "users")
        let user = User(name: name, username: username)
        let createdResource = try await request.save(user)
        if createdResource != nil { showCreateView = false }
    }
}
