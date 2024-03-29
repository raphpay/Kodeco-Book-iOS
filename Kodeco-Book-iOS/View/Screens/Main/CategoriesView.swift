//
//  CategoriesView.swift
//  Kodeco-Book-iOS
//
//  Created by Raphaël Payet on 24/01/2024.
//

import SwiftUI

struct CategoriesView: View {
    @State private var categories: [Category] = []
    @State private var showCreateView = false
    
    var body: some View {
        NavigationStack {
            VStack {
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
            .navigationDestination(isPresented: $showCreateView, destination: {
                CreateCategoryView(showCreateView: $showCreateView)
            })
            .toolbar {
                ToolbarItem {
                    Button {
                        showCreateView = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .onAppear {
                Task { try await fetchCategories() }
            }
        }
    }
    
    func fetchCategories() async throws {
        let request = ResourceRequest<Category>(resourcePath: "categories")
        let resources = try await request.getAll()
        DispatchQueue.main.async {
            self.categories = resources
        }
    }
}

#Preview {
    CategoriesView()
}
