//
//  Kodeco_Book_iOSApp.swift
//  Kodeco-Book-iOS
//
//  Created by Raphaël Payet on 24/01/2024.
//

import SwiftUI

@main
struct Kodeco_Book_iOSApp: App {
    @StateObject private var authProvider = AuthProvider()
    
    var body: some Scene {
        WindowGroup {
            if authProvider.isLoggedIn {
                MainTabView()
                    .environmentObject(authProvider)
            } else {
                LoginView()
                    .environmentObject(authProvider)
            }
        }
    }
}

struct MainTabView: View {
    @EnvironmentObject private var authProvider: AuthProvider
    
    var body: some View {
        TabView {
            UsersView()
                .environmentObject(authProvider)
                .tabItem {
                    Label("Users", systemImage: "person.2")
                }

            AcronymsView()
                .tabItem {
                    Label("Acronyms", systemImage: "character.magnify")
                }

            CategoriesView()
                .tabItem {
                    Label("Categories", systemImage: "tag")
                }
        }
    }
}
