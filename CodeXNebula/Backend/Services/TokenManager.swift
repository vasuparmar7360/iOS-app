//
//  TokenManager.swift
//  CodeXNebula
//

import Foundation

class TokenManager {
    static let shared = TokenManager()
    
    private var tokenCache: [String: String] = [:]
    
    private init() {}
    
    func getCachedResponse(for prompt: String) -> String? {
        return tokenCache[prompt]
    }
    
    func cacheResponse(_ response: String, for prompt: String) {
        tokenCache[prompt] = response
    }
    
    func clearCache() {
        tokenCache.removeAll()
    }
}
