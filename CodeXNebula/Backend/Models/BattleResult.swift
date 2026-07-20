//
//  BattleResult.swift
//  CodeXNebula
//

import Foundation

struct BattleResult: Identifiable, Hashable {
    let id: String
    let winnerId: String? // nil if draw
    let runnerUpId: String?
    let xpEarned: Int
    let baseBattleXp: Int
    let completionTimeSeconds: Int
    let status: String
    let accuracyPercentage: Double
}
