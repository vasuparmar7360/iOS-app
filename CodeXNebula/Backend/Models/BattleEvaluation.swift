//
//  BattleEvaluation.swift
//  CodeXNebula
//

import Foundation

struct BattleEvaluation: Identifiable, Hashable {
    let id: String
    let battleId: String
    let problemTitle: String
    let languageId: String
    let difficulty: String
    let player1Score: PlayerScore
    let player2Score: PlayerScore
    let decision: WinnerDecision
}
