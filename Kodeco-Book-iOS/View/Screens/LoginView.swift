//
//  LoginView.swift
//  Kodeco-Book-iOS
//
//  Created by Raphaël Payet on 25/01/2024.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject private var authProvider: AuthProvider
    
    @State private var username = ""
    @State private var password = ""
    
    var body: some View {
        VStack {
            TextField("Username", text: $username)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .textFieldStyle(.roundedBorder)
            
            SecureField("Password", text: $password)
                .textFieldStyle(.roundedBorder)
            
            Button {
                Task {
                    try await authProvider.login(username: username, password: password)
                }
            } label: {
                Text("Login")
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}
