//
//  CreateCategoryView.swift
//  Kodeco-Book-iOS
//
//  Created by Raphaël Payet on 24/01/2024.
//

import SwiftUI

struct CreateCategoryView: View {
    @Binding var showCreateView: Bool
    @State private var name = ""
    
    var body: some View {
        Form {
            TextField("Name", text: $name)
                .textInputAutocapitalization(.words)
            
            Button {
                Task { try await save() }
            } label: {
                Text("Save")
            }
        }
    }
    
    func save() async throws {
        guard !name.isEmpty else { return }
        let request = ResourceRequest<Category>(resourcePath: "categories")
        let category = Category(name: name)
        let createdResource = try await request.save(category)
        if createdResource != nil { showCreateView = false }
    }
}
