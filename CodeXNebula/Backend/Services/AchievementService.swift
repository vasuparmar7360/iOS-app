//
//  AchievementService.swift
//  CodeXNebula
//

import Foundation

class AchievementService {
    func getAchievements() async throws -> [Achievement] {
        try await Task.sleep(nanoseconds: 500_000_000)
        
        let user = UserStorageService.shared.getCurrentUserSession()
        let problemsCount = user?.completedProblems.count ?? 0
        let wins = user?.battleWins ?? 0
        
        return [
            Achievement(id: "1", title: "First Login", description: "Logged in to CodeX Nebula for the first time.", category: "Exploration", badge: .bronze, isUnlocked: true, unlockedAt: Date().addingTimeInterval(-86400 * 10)),
            Achievement(id: "2", title: "First Problem Solved", description: "Successfully solved a coding problem.", category: "Learning", badge: .silver, isUnlocked: problemsCount > 0, unlockedAt: problemsCount > 0 ? Date() : nil),
            Achievement(id: "3", title: "Master Python", description: "Complete all Python chapters.", category: "Learning", badge: .platinum, isUnlocked: problemsCount >= 10, unlockedAt: problemsCount >= 10 ? Date() : nil),
            Achievement(id: "4", title: "10 Battles Won", description: "Defeated 10 opponents in Battle Arena.", category: "Battle", badge: .gold, isUnlocked: wins >= 10, unlockedAt: wins >= 10 ? Date() : nil),
            Achievement(id: "5", title: "7-Day Streak", description: "Logged in for 7 consecutive days.", category: "Consistency", badge: .silver, isUnlocked: (user?.dailyStreak ?? 1) >= 7, unlockedAt: (user?.dailyStreak ?? 1) >= 7 ? Date() : nil)
        ]
    }
    
    func getStreakInfo() async throws -> DailyStreak {
        let streak = UserStorageService.shared.getCurrentUserSession()?.dailyStreak ?? 1
        return DailyStreak(currentStreak: streak, longestStreak: streak, lastLoginDate: Date(), todayReward: 50, todayClaimed: false)
    }
}
