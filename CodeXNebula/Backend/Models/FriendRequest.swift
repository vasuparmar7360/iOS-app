//
//  FriendRequest.swift
//  CodeXNebula
//

import Foundation

enum FriendRequestStatus: String, Codable {
    case pending
    case accepted
    case rejected
}

struct FriendRequest: Identifiable, Codable, Hashable {
    let id: String
    let senderId: String
    let receiverId: String
    var status: FriendRequestStatus
    let timestamp: Date
}
