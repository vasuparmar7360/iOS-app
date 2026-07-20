//
//  LeaderboardService.swift
//  CodeXNebula
//

import Foundation

class LeaderboardService {
    func getGlobalLeaderboard() async throws -> [LeaderboardPlayer] {
        try await Task.sleep(nanoseconds: 1_000_000_000)
        let currentUser = UserStorageService.shared.getCurrentUserSession()
        
        let me = LeaderboardPlayer(
            id: currentUser?.id ?? "currentUser",
            rank: 3,
            username: currentUser?.username ?? "You",
            avatarUrl: nil,
            level: currentUser?.level ?? 1,
            xp: currentUser?.xp ?? 0,
            problemsSolved: currentUser?.completedProblems.count ?? 0,
            battleWins: currentUser?.battleWins ?? 0
        )
        
        return [
            LeaderboardPlayer(id: "1", rank: 1, username: "NeoCoder", avatarUrl: nil, level: 42, xp: 52000, problemsSolved: 1050, battleWins: 300),
            LeaderboardPlayer(id: "2", rank: 2, username: "CyberSamurai", avatarUrl: nil, level: 40, xp: 48000, problemsSolved: 900, battleWins: 250),
            me,
            LeaderboardPlayer(id: "4", rank: 4, username: "ByteHacker", avatarUrl: nil, level: 35, xp: 39000, problemsSolved: 750, battleWins: 180),
            LeaderboardPlayer(id: "5", rank: 5, username: "SyntaxError", avatarUrl: nil, level: 30, xp: 30000, problemsSolved: 600, battleWins: 150)
        ]
    }
}
