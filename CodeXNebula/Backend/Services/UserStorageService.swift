//
//  UserStorageService.swift
//  CodeXNebula
//
//  Manages persistence of user accounts in local storage (UserDefaults).
//

import Foundation

class UserStorageService {
    static let shared = UserStorageService()
    
    private let usersKey = "CodeXNebula_SavedUsers"
    private let currentUserKey = "CodeXNebula_CurrentUserSession"
    
    private init() {}
    
    // MARK: - Database Operations
    
    /// Returns all users registered on this device.
    func getAllUsers() -> [String: User] {
        guard let data = UserDefaults.standard.data(forKey: usersKey),
              let users = try? JSONDecoder().decode([String: User].self, from: data) else {
            return [:]
        }
        return users
    }
    
    /// Saves the database of users.
    private func saveAllUsers(_ users: [String: User]) {
        if let encoded = try? JSONEncoder().encode(users) {
            UserDefaults.standard.set(encoded, forKey: usersKey)
        }
    }
    
    /// Adds or updates a user in the local database.
    func saveUser(_ user: User) {
        var users = getAllUsers()
        users[user.id] = user
        saveAllUsers(users)
    }
    
    // MARK: - Session Management
    
    /// Sets the currently active user session.
    func saveCurrentUserSession(_ user: User) {
        if let encoded = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(encoded, forKey: currentUserKey)
        }
    }
    
    /// Retrieves the currently active user session, if any.
    func getCurrentUserSession() -> User? {
        guard let data = UserDefaults.standard.data(forKey: currentUserKey),
              let user = try? JSONDecoder().decode(User.self, from: data) else {
            return nil
        }
        return user
    }
    
    /// Clears the current user session (logout).
    func clearCurrentUserSession() {
        UserDefaults.standard.removeObject(forKey: currentUserKey)
    }
}
