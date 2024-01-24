//
//  ResourceRequest.swift
//  Kodeco-Book-iOS
//
//  Created by Raphaël Payet on 24/01/2024.
//

import Foundation

enum ResourceRequestError: Error {
    case noData, decodingError
}

struct ResourceRequest<ResourceType> where ResourceType: Codable {
    let baseURL = "http://localhost:8080/api/"
    let resourceURL: URL
    
    init(resourcePath: String) {
        guard let resourceURL = URL(string: baseURL) else {
            fatalError("Failed to convert baseURL to a URL")
        }
        self.resourceURL = resourceURL.appendingPathComponent(resourcePath)
    }

    func getAll() async throws -> [ResourceType] {
        var resources: [ResourceType] = []
        
        let (data, response) = try await URLSession.shared.data(from: resourceURL)
        
        do {
            resources = try JSONDecoder().decode([ResourceType].self, from: data)
        } catch {
            throw ResourceRequestError.decodingError
        }
        
        return resources
    }
}
