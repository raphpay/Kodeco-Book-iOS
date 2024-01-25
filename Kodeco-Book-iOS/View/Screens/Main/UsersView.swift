//
//  UsersView.swift
//  Kodeco-Book-iOS
//
//  Created by Raphaël Payet on 24/01/2024.
//

import SwiftUI

struct UsersView: View {
    @EnvironmentObject private var authProvider: AuthProvider
    @State private var users: [User] = []
    @State private var showCreateView = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                if users.isEmpty {
                    ContentUnavailableView("No users yet", systemImage: "person.2", description: Text("Create one over here"))
                } else {
                    List {
                        ForEach(users) { user in
                            VStack(alignment: .leading) {
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
            .toolbar {
                ToolbarItem {
                    Button {
                        showCreateView = true
                    } label: {
                        Image(systemName: "plus")
                    }

                }
                ToolbarItem {
                    Button {
                        authProvider.logout()
                    } label: {
                        Image(systemName: "door.right.hand.open")
                    }

                }
            }
            .navigationDestination(isPresented: $showCreateView) {
                CreateUserView(showCreateView: $showCreateView)
            }
            .onAppear {
                Task { try await fetchUsers() }
            }
        }
    }
    
    func fetchUsers() async throws {
        let request = ResourceRequest<User>(resourcePath: "users")
        let resources = try await request.getAll()
        DispatchQueue.main.async {
            self.users = resources
        }
    }
}

#Preview {
    UsersView()
}
