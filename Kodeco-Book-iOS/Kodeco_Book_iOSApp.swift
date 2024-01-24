//
//  Kodeco_Book_iOSApp.swift
//  Kodeco-Book-iOS
//
//  Created by Raphaël Payet on 24/01/2024.
//

import SwiftUI

@main
struct Kodeco_Book_iOSApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                TabView {
                    UsersView()
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
    }
}
