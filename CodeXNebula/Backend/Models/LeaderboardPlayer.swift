//
//  LeaderboardPlayer.swift
//  CodeXNebula
//

import Foundation

struct LeaderboardPlayer: Identifiable, Hashable {
    let id: String
    let rank: Int
    let username: String
    let avatarUrl: String?
    let level: Int
    let xp: Int
    let problemsSolved: Int
    let battleWins: Int
}
