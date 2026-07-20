//
//  UserPresence.swift
//  CodeXNebula
//

import Foundation

enum PresenceStatus: String, Codable {
    case online
    case offline
    case inBattle
    case away
}

struct UserPresence: Codable, Hashable {
    let userId: String
    var status: PresenceStatus
    var lastActive: Date
}
