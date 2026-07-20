//
//  PlayerScore.swift
//  CodeXNebula
//

import Foundation

struct PlayerScore: Identifiable, Hashable {
    let id: String
    let username: String
    let code: String
    let metrics: CodeMetrics
    let isWinner: Bool
    let xpAwarded: Int
    let estimatedTimeComplexity: String
    let estimatedSpaceComplexity: String
    let optimizationSuggestions: [String]
}
