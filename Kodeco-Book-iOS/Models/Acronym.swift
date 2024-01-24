//
//  Acronym.swift
//  Kodeco-Book-iOS
//
//  Created by Raphaël Payet on 24/01/2024.
//

import Foundation

final class Acronym: Codable, Identifiable {
    var id: UUID?
    var short: String
    var long: String
    var user: AcronymUser
    
    init(short: String, long: String, userID: UUID) {
        self.short = short
        self.long = long
        let user = AcronymUser(id: userID)
        self.user = user
    }
}

final class AcronymUser: Codable {
    var id: UUID
    
    init(id: UUID) {
        self.id = id
    }
}

struct CreateAcronymData: Codable {
    let short: String
    let long: String
    let userID: UUID
}

extension Acronym {
    func toCreateData() -> CreateAcronymData {
        CreateAcronymData(short: self.short, long: self.long, userID: self.user.id)
    }
}
