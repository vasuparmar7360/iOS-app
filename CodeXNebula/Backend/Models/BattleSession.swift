//
//  BattleSession.swift
//  CodeXNebula
//

import Foundation

enum BattleState: String, Codable {
    case waiting
    case countdown
    case inProgress
    case evaluating
    case finished
    case cancelled
}

struct BattleSession: Identifiable, Codable, Hashable {
    let id: String
    let problemId: String
    let languageId: String
    var player1Id: String
    var player2Id: String
    var state: BattleState
    var startedAt: Date?
    var player1Ready: Bool
    var player2Ready: Bool
    var player1Submitted: Bool
    var player2Submitted: Bool
    var player1Code: String?
    var player2Code: String?
    var winnerId: String?
}
