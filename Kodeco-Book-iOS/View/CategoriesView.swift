//
//  CategoriesView.swift
//  Kodeco-Book-iOS
//
//  Created by Raphaël Payet on 24/01/2024.
//

import SwiftUI

struct Category: Identifiable, Codable {
    var id: UUID?
    var name: String
}

struct CategoriesView: View {
    @State private var categories: [Category] = []
    
    var body: some View {
        NavigationStack {
            if categories.isEmpty {
                ContentUnavailableView("No categories yet", systemImage: "tag", description: Text("Create one over here"))
            } else {
                List {
                    ForEach(categories) { category in
                        Text(category.name)
                            .font(.system(size: 18))
                            .bold()
                    }
                }
            }
        }
    }
}

#Preview {
    CategoriesView()
}
