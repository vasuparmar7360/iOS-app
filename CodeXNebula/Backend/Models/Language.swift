//
//  Language.swift
//  CodeXNebula
//

import Foundation

struct Language: Identifiable, Hashable {
    let id: String
    let name: String
    let iconName: String
    let totalProblems: Int
    var completedProblems: Int
    
    var progress: Double {
        guard totalProblems > 0 else { return 0.0 }
        return Double(completedProblems) / Double(totalProblems)
    }
}
