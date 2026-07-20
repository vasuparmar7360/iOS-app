//
//  BattleSubmission.swift
//  CodeXNebula
//

import Foundation

struct BattleSubmission: Identifiable, Hashable {
    let id: String
    let playerId: String
    let code: String
    let executionTime: Double
    let isCorrect: Bool
    let submittedAt: Date
}
