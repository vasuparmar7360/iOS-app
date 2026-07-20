//
//  Friend.swift
//  CodeXNebula
//

import Foundation

struct Friend: Identifiable, Hashable {
    let id: String
    let username: String
    let avatarUrl: String?
    let level: Int
    let isOnline: Bool
    
    // For preview and dummy data
    static let dummyFriends: [Friend] = [
        Friend(id: "1", username: "CyberNinja", avatarUrl: nil, level: 42, isOnline: true),
        Friend(id: "2", username: "NeonCoder", avatarUrl: nil, level: 38, isOnline: true),
        Friend(id: "3", username: "ByteWizard", avatarUrl: nil, level: 55, isOnline: false),
        Friend(id: "4", username: "GlitchMaster", avatarUrl: nil, level: 27, isOnline: true),
        Friend(id: "5", username: "NullPointer", avatarUrl: nil, level: 12, isOnline: false)
    ]
}
