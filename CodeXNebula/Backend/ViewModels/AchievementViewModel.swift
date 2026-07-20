//
//  AchievementViewModel.swift
//  CodeXNebula
//

import Foundation
import SwiftUI

@MainActor
class AchievementViewModel: ObservableObject {
    @Published var achievements: [Achievement] = []
    @Published var streak: DailyStreak?
    @Published var isLoading = false
    
    private let service = AchievementService()
    
    func loadData() async {
        isLoading = true
        do {
            async let fetchAchievements = service.getAchievements()
            async let fetchStreak = service.getStreakInfo()
            
            let (achs, streakInfo) = try await (fetchAchievements, fetchStreak)
            self.achievements = achs
            self.streak = streakInfo
        } catch {
            AppLogger.error("Failed to load achievements: \(error)")
        }
        isLoading = false
    }
}
