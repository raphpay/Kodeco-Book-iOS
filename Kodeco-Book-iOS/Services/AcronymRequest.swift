//
//  AcronymRequest.swift
//  Kodeco-Book-iOS
//
//  Created by Raphaël Payet on 24/01/2024.
//

import Foundation

struct AcronymRequest {
    let resourceURL: URL
    
    init(acronymID: UUID) {
        let resourceString = "http://localhost:8080/api/acronyms/\(acronymID)"
        guard let resourceURL = URL(string: resourceString) else { fatalError("Unable to create URL") }
        self.resourceURL = resourceURL
    }
    
    // MARK: - Read
    func getUser() async throws -> User? {
        var user: User?
        let url = resourceURL.appendingPathComponent("user")
        
        var data: Data
        do {
            (data, _) = try await URLSession.shared.data(from: url)
        } catch {
            throw ResourceRequestError.noData
        }
        
        do {
            user = try JSONDecoder().decode(User.self, from: data)
        } catch {
            throw ResourceRequestError.decodingError
        }
        
        return user
    }
    
    func getCategories() async throws -> [Category]? {
        var categories: [Category]?
        
        let url = resourceURL.appendingPathComponent("categories")
        
        
        var data: Data
        do {
            (data, _) = try await URLSession.shared.data(from: url)
        } catch {
            throw ResourceRequestError.noData
        }
        
        do {
            categories = try JSONDecoder().decode([Category].self, from: data)
        } catch {
            throw ResourceRequestError.decodingError
        }
        
        return categories
    }
    
    // MARK: - Update
    func update(with updateData: CreateAcronymData) async throws -> Acronym? {
        var acronym: Acronym?
        
        var urlRequest = URLRequest(url: resourceURL)
        urlRequest.httpMethod = "PUT"
        urlRequest.httpBody = try JSONEncoder().encode(updateData)
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        var data: Data
        
        do {
            (data, _) = try await URLSession.shared.data(for: urlRequest)
        } catch {
            throw ResourceRequestError.noData
        }
        
        do {
            acronym = try JSONDecoder().decode(Acronym.self, from: data)
        } catch {
            throw ResourceRequestError.decodingError
        }
        
        return acronym
    }
}
