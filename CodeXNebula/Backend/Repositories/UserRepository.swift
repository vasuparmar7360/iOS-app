//
//  UserRepository.swift
//  CodeXNebula
//

import Foundation

class UserRepository {
    static let shared = UserRepository()
    private let storage = UserStorageService.shared
    
    private init() {}
    
    func saveUser(_ user: User) async throws {
        storage.saveUser(user)
        if FirebaseService.shared.isAvailable {
            // Upload to Firestore users collection
        }
    }
    
    func getUser(id: String) async throws -> User? {
        if let localUser = storage.getAllUsers()[id] {
            return localUser
        }
        if FirebaseService.shared.isAvailable {
            // Download from Firestore
        }
        return nil
    }
    
    func updateXP(userId: String, newXP: Int) async throws {
        if var user = storage.getAllUsers()[userId] {
            user.xp = newXP
            storage.saveUser(user)
        }
        if FirebaseService.shared.isAvailable {
            // Update in Firestore
        }
    }
}
