//
//  Token.swift
//  Kodeco-Book-iOS
//
//  Created by Raphaël Payet on 25/01/2024.
//

import Foundation

final class Token: Codable {
    var id: UUID?
    var value: String

    init(value: String) {
        self.value = value
    }
}
