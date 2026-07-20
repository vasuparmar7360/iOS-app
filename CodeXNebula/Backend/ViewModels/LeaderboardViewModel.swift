//
//  LeaderboardViewModel.swift
//  CodeXNebula
//

import Foundation
import SwiftUI

@MainActor
class LeaderboardViewModel: ObservableObject {
    @Published var players: [LeaderboardPlayer] = []
    @Published var isLoading = false
    
    private let service = LeaderboardService()
    
    func loadLeaderboard() async {
        isLoading = true
        do {
            players = try await service.getGlobalLeaderboard()
        } catch {
            AppLogger.error("Failed to load leaderboard: \(error)")
        }
        isLoading = false
    }
}
