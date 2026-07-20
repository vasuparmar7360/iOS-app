//
//  FriendService.swift
//  CodeXNebula
//

import Foundation

class FriendService {
    static let shared = FriendService()
    
    private init() {}
    
    func getFriends(userId: String) async throws -> [Friend] {
        return try await FriendRepository.shared.fetchFriends(userId: userId)
    }
    
    func search(query: String) async throws -> [User] {
        return try await FriendRepository.shared.searchUsers(query: query)
    }
    
    func sendFriendRequest(to receiverId: String) async throws {
        let senderId = "currentUser" // Should get from AppState
        try await FriendRepository.shared.sendRequest(from: senderId, to: receiverId)
    }
    
    func acceptRequest(_ requestId: String) async throws {
        try await FriendRepository.shared.respondToRequest(requestId: requestId, accept: true)
    }
    
    func rejectRequest(_ requestId: String) async throws {
        try await FriendRepository.shared.respondToRequest(requestId: requestId, accept: false)
    }
}
