//
//  Battle.swift
//  CodeXNebula
//

import Foundation

enum BattleStatus: String, Hashable {
    case waiting = "Waiting"
    case inProgress = "In Progress"
    case completed = "Completed"
    case cancelled = "Cancelled"
}

struct Battle: Identifiable, Hashable {
    let id: String
    let problemId: String
    let languageId: String
    var status: BattleStatus
    let players: [BattlePlayer]
    let durationMinutes: Int
    let startTime: Date?
    let endTime: Date?
    
    // History dummy data
    static let dummyHistory: [Battle] = [
        Battle(id: "b1", problemId: "p1", languageId: "python", status: .completed, players: [], durationMinutes: 10, startTime: Date().addingTimeInterval(-3600), endTime: Date().addingTimeInterval(-3000)),
        Battle(id: "b2", problemId: "p2", languageId: "swift", status: .completed, players: [], durationMinutes: 15, startTime: Date().addingTimeInterval(-86400), endTime: Date().addingTimeInterval(-85000))
    ]
}
