//
//  ResourceRequest.swift
//  Kodeco-Book-iOS
//
//  Created by Raphaël Payet on 24/01/2024.
//

import Foundation

enum ResourceRequestError: Error {
    case noData, decodingError, encodingError
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
    
    // MARK: - Create
    func save<CreateType>(_ saveData: CreateType) async throws -> ResourceType? where CreateType: Codable {
        var createdResource: ResourceType?
        
        guard let token = Auth.shared.token else { return createdResource }
        
        var urlRequest = URLRequest(url: resourceURL)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        urlRequest.httpBody = try JSONEncoder().encode(saveData)
        
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        createdResource = try JSONDecoder().decode(ResourceType.self, from: data)
        
        return createdResource
    }

    // MARK: - Read
    func getAll() async throws -> [ResourceType] {
        var resources: [ResourceType] = []
        
        let (data, _) = try await URLSession.shared.data(from: resourceURL)
        
        do {
            resources = try JSONDecoder().decode([ResourceType].self, from: data)
        } catch {
            throw ResourceRequestError.decodingError
        }
        
        return resources
    }
}
