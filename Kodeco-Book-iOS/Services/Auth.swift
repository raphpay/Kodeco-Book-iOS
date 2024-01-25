//
//  Auth.swift
//  Kodeco-Book-iOS
//
//  Created by Raphaël Payet on 25/01/2024.
//

import Foundation
import UIKit
import Security

enum AuthResult {
  case success
  case failure
}

class Auth {
    static let keychainKey = "TIL-API-KEY"
    static let shared = Auth()
    
    private init() {}
    
    var token: String? {
        get {
            Keychain.load(key: Auth.keychainKey)
        }
        set {
            if let newToken = newValue {
                Keychain.save(key: Auth.keychainKey, data: newToken)
            } else {
                Keychain.delete(key: Auth.keychainKey)
            }
        }
    }
    
    func login(username: String, password: String) async throws -> AuthResult {
        var result = AuthResult.failure
        let path = "http://localhost:8080/api/users/login"
        guard let url = URL(string: path) else {
            fatalError("Failed to convert URL")
        }
        
        guard let loginString = "\(username):\(password)".data(using: .utf8)?.base64EncodedString() else {
            fatalError("Failed to encode credentials")
        }
        
        var loginRequest = URLRequest(url: url)
        loginRequest.addValue("Basic \(loginString)", forHTTPHeaderField: "Authorization")
        loginRequest.httpMethod = "POST"
        
        var data: Data
        do {
            (data, _) = try await URLSession.shared.data(for: loginRequest)
        } catch {
            throw ResourceRequestError.noData
        }
        
        do {
            let token = try JSONDecoder().decode(Token.self, from: data)
            self.token = token.value
            result = .success
        } catch {
            throw ResourceRequestError.decodingError
        }
        
        return result
    }
    
    func logout() {
        token = nil
    }
}

enum Keychain {
    @discardableResult
    static func save(key: String, data: String) -> OSStatus {
        let bytes: [UInt8] = .init(data.utf8)
        let bytesAsData = Data(bytes)
        let query = [kSecClass: kSecClassGenericPassword, kSecAttrAccount: key, kSecValueData: bytesAsData] as [CFString: Any]
        
        SecItemDelete(query as CFDictionary)
        
        return SecItemAdd(query as CFDictionary, nil)
    }
    
    @discardableResult
    static func delete(key: String) -> OSStatus {
        let query = [kSecClass: kSecClassGenericPassword, kSecAttrAccount: key] as [CFString: Any]
        
        return SecItemDelete(query as CFDictionary)
    }

    static func load(key: String) -> String? {
        let query = [kSecClass: kSecClassGenericPassword,
                kSecAttrAccount: key,
                kSecReturnData: kCFBooleanTrue as Any,
                kSecMatchLimit: kSecMatchLimitOne
        ] as [CFString: Any]

        var dataTypeRef: AnyObject?

        let status: OSStatus = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)

        if status == noErr {
            guard let data = dataTypeRef as? Data else {
                return nil
            }
            return String(decoding: data, as: UTF8.self)
        } else {
            return nil
        }
    }
}
