//
//  AuthProvider.swift
//  Kodeco-Book-iOS
//
//  Created by Raphaël Payet on 25/01/2024.
//

import SwiftUI

final class AuthProvider: ObservableObject {
    @Published var isLoggedIn: Bool = {
        Auth.shared.token != nil
    }()
    
    func login(username: String, password: String) async throws {
        let result = try await Auth.shared.login(username: username, password: password)
        DispatchQueue.main.async {
            withAnimation {
                self.isLoggedIn = result == .success
            }
        }
    }
    
    func logout() {
        Auth.shared.logout()
        withAnimation {
            self.isLoggedIn = false
        }
    }
}
