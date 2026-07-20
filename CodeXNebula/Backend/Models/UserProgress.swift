//
//  UserProgress.swift
//  CodeXNebula
//
//  Models for tracking user's learning journey and daily missions.
//

import Foundation

struct LearningLanguage: Identifiable, Hashable {
    let id: String
    let name: String
    let progress: Double // 0.0 to 1.0
    let iconName: String
}

struct DailyMission: Identifiable {
    let id: String
    let title: String
    let description: String
    let xpReward: Int
    var isCompleted: Bool
    let totalTasks: Int
    var completedTasks: Int
}
