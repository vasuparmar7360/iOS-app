//
//  Achievement.swift
//  CodeXNebula
//

import Foundation

struct Achievement: Identifiable, Hashable {
    let id: String
    let title: String
    let description: String
    let category: String
    let badge: Badge
    let isUnlocked: Bool
    let unlockedAt: Date?
}
