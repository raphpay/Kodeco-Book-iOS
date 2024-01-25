//
//  User.swift
//  Kodeco-Book-iOS
//
//  Created by Raphaël Payet on 24/01/2024.
//

import Foundation

final class User: Identifiable, Codable {
    var id: UUID?
    var name: String
    var username: String
    
    init(id: UUID? = nil, name: String, username: String) {
        self.id = id
        self.name = name
        self.username = username
    }
}

final class CreateUserData: Codable {
    var id: UUID?
    var name: String
    var username: String
    var password: String
    
    init(id: UUID? = nil, name: String, username: String, password: String) {
        self.id = id
        self.name = name
        self.username = username
        self.password = password
    }
}
