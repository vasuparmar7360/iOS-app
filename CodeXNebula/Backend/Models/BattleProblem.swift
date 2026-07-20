//
//  BattleProblem.swift
//  CodeXNebula
//

import Foundation

struct BattleProblem: Identifiable, Hashable {
    let id: String
    let title: String
    let description: String
    let difficulty: ProblemDifficulty
    let starterCode: String
}
