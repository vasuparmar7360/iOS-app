//
//  HomeViewModel.swift
//  CodeXNebula
//
//  ViewModel for managing the Home Dashboard state and mocked data.
//

import SwiftUI

@MainActor
class HomeViewModel: ObservableObject {
    
    @Published var isLoading: Bool = false
    @Published var currentUser: User?
    
    // Progress Data
    @Published var dailyMissions: [DailyMission] = []
    @Published var learningLanguages: [LearningLanguage] = []
    
    func setup(with user: User?) {
        guard let user = user else { return }
        self.currentUser = user
        loadDashboardData()
    }
    
    func refreshData() async {
        isLoading = true
        // Simulate network delay for pull-to-refresh
        try? await Task.sleep(nanoseconds: 1_200_000_000)
        loadDashboardData()
        isLoading = false
    }
    
    private func loadDashboardData() {
        if let updatedUser = UserStorageService.shared.getCurrentUserSession() {
            self.currentUser = updatedUser
        }
        
        self.dailyMissions = [
            DailyMission(
                id: "m1",
                title: "Complete 1 coding challenge",
                description: "Solve any challenge to earn bonus XP today.",
                xpReward: 50,
                isCompleted: (currentUser?.completedProblems.count ?? 0) > 0,
                totalTasks: 1,
                completedTasks: min(1, currentUser?.completedProblems.count ?? 0)
            ),
            DailyMission(
                id: "m2",
                title: "Login Streak",
                description: "Log in for 3 consecutive days.",
                xpReward: 20,
                isCompleted: (currentUser?.dailyStreak ?? 1) >= 3,
                totalTasks: 3,
                completedTasks: min(3, currentUser?.dailyStreak ?? 1)
            )
        ]
        
        // Dynamic based on completed problems
        let completedCount = currentUser?.completedProblems.count ?? 0
        self.learningLanguages = [
            LearningLanguage(id: "l1", name: "Swift", progress: min(1.0, Double(completedCount) / 10.0), iconName: "swift"),
            LearningLanguage(id: "l2", name: "Python", progress: min(1.0, Double(completedCount) / 15.0), iconName: "terminal")
        ]
    }
    
    var nextLevelXP: Int {
        // Formula for next level XP requirement
        let currentLvl = currentUser?.level ?? 1
        return currentLvl * 500
    }
}
