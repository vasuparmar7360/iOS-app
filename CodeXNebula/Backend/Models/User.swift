//
//  User.swift
//  CodeXNebula
//
//  Data model representing a CodeX Nebula user.
//

import Foundation

struct User: Identifiable, Codable {
    let id: String
    var fullName: String
    var username: String
    var email: String
    var passwordHash: String // Placeholder for secure backend auth
    var xp: Int
    var level: Int
    var completedProblems: [String]
    var unlockedAchievements: [String]
    var battleWins: Int
    var battleLosses: Int
    var dailyStreak: Int
    let createdAt: Date
    
    // Default initialiser for new signups
    init(
        id: String = UUID().uuidString,
        fullName: String,
        username: String,
        email: String,
        passwordHash: String,
        xp: Int = 100,
        level: Int = 1,
        completedProblems: [String] = [],
        unlockedAchievements: [String] = [],
        battleWins: Int = 0,
        battleLosses: Int = 0,
        dailyStreak: Int = 1,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.fullName = fullName
        self.username = username
        self.email = email
        self.passwordHash = passwordHash
        self.xp = xp
        self.level = level
        self.completedProblems = completedProblems
        self.unlockedAchievements = unlockedAchievements
        self.battleWins = battleWins
        self.battleLosses = battleLosses
        self.dailyStreak = dailyStreak
        self.createdAt = createdAt
    }
}
