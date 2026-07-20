//
//  BattlePlayer.swift
//  CodeXNebula
//

import Foundation

struct BattlePlayer: Identifiable, Hashable {
    let id: String
    let username: String
    let level: Int
    var isReady: Bool
    var hasFinished: Bool
    var executionTimeMs: Double?
    var passedTestCases: Int?
    var totalTestCases: Int?
}
