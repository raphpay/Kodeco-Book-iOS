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
    @State private var password = ""
    @Binding var showCreateView: Bool
    
    var body: some View {
        Form {
            TextField("Name", text: $name)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.words)
            
            TextField("Username", text: $username)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
            
            SecureField("Password", text: $password)
            
            Button {
                Task { try await save() }
            } label: {
                Text("Save")
            }
        }
    }
    
    func save() async throws {
        let request = ResourceRequest<User>(resourcePath: "users")
        let userData = CreateUserData(name: name, username: username, password: password)
        let createdResource = try await request.save(userData)
        if createdResource != nil { showCreateView = false }
    }
}
