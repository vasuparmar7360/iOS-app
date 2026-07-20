//
//  DailyStreak.swift
//  CodeXNebula
//

import Foundation

struct DailyStreak: Hashable {
    let currentStreak: Int
    let longestStreak: Int
    let lastLoginDate: Date
    let todayReward: Int
    let todayClaimed: Bool
}
