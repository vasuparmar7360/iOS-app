//
//  FirebaseService.swift
//  CodeXNebula
//

import Foundation

class FirebaseService {
    static let shared = FirebaseService()
    
    private init() {}
    
    var isAvailable: Bool {
        return FirebaseConfiguration.shared.isConfigured
    }
}
