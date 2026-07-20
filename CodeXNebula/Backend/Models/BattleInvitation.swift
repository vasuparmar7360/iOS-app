//
//  BattleInvitation.swift
//  CodeXNebula
//

import Foundation

struct BattleInvitation: Identifiable, Hashable {
    let id: String
    let senderId: String
    let receiverId: String
    let problemId: String
    let languageId: String
    let durationMinutes: Int
    let expiresAt: Date
}
