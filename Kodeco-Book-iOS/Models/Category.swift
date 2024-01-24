//
//  Category.swift
//  Kodeco-Book-iOS
//
//  Created by Raphaël Payet on 24/01/2024.
//

import Foundation

final class Category: Identifiable, Codable {
    var id: UUID?
    var name: String
    
    init(id: UUID? = nil, name: String) {
        self.id = id
        self.name = name
    }
}
