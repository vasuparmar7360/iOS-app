//
//  CodingProblem.swift
//  CodeXNebula
//

import Foundation
import SwiftUI

enum ProblemDifficulty: String, CaseIterable, Hashable {
    case easy = "Easy"
    case medium = "Medium"
    case hard = "Hard"
    
    var xpReward: Int {
        switch self {
        case .easy: return 20
        case .medium: return 50
        case .hard: return 100
        }
    }
    
    var color: Color {
        switch self {
        case .easy: return AppColors.success
        case .medium: return AppColors.warning
        case .hard: return AppColors.error
        }
    }
}

struct CodingProblem: Identifiable, Hashable {
    let id: String
    let title: String
    let description: String
    let languageId: String
    let chapterId: String
    let difficulty: ProblemDifficulty
    let xpReward: Int
    var isCompleted: Bool
    
    // New fields for Problem Detail
    let constraints: [String]?
    let notes: String?
    let sampleInput: String?
    let sampleOutput: String?
    let explanation: String?
    let starterCode: String?
    let estimatedTime: String?
    let tags: [String]?
    
    // Default initializer to handle backwards compatibility and mock data
    init(id: String, title: String, description: String, languageId: String, chapterId: String, difficulty: ProblemDifficulty, xpReward: Int, isCompleted: Bool, constraints: [String]? = nil, notes: String? = nil, sampleInput: String? = nil, sampleOutput: String? = nil, explanation: String? = nil, starterCode: String? = nil, estimatedTime: String? = nil, tags: [String]? = nil) {
        self.id = id
        self.title = title
        self.description = description
        self.languageId = languageId
        self.chapterId = chapterId
        self.difficulty = difficulty
        self.xpReward = xpReward
        self.isCompleted = isCompleted
        
        self.constraints = constraints ?? ["1 <= N <= 10^4", "Time Limit: 2.0s"]
        self.notes = notes ?? "Pay attention to edge cases."
        self.sampleInput = sampleInput ?? "5\n1 2 3 4 5"
        self.sampleOutput = sampleOutput ?? "15"
        self.explanation = explanation ?? "The sum of the array elements is 15."
        self.starterCode = starterCode
        self.estimatedTime = estimatedTime ?? "15 mins"
        self.tags = tags ?? ["Algorithms", "Logic"]
    }
}
