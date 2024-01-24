//
//  UsersView.swift
//  Kodeco-Book-iOS
//
//  Created by Raphaël Payet on 24/01/2024.
//

import SwiftUI

struct User: Identifiable, Codable {
    var id: UUID?
    var name: String
    var username: String
}

struct UsersView: View {
    @State private var users: [User] = []
    
    var body: some View {
        NavigationStack {
            if users.isEmpty {
                ContentUnavailableView("No users yet", systemImage: "person.2", description: Text("Create one over here"))
            } else {
                List {
                    ForEach(users) { user in
                        Text(user.name)
                            .font(.system(size: 18))
                            .bold()
                        Text(user.username)
                            .font(.system(size: 15))
                    }
                }
            }
        }
    }
}

#Preview {
    UsersView()
}
