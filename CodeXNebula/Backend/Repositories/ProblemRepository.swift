//
//  ProblemRepository.swift
//  CodeXNebula
//

import Foundation

class ProblemRepository {
    static let shared = ProblemRepository()
    
    private init() {}
    
    func getChapters(for languageId: String) async -> [Chapter] {
        if FirebaseService.shared.isAvailable {
            // Fetch from Firestore
        }
        return await ProblemDataService.shared.getChapters(for: languageId)
    }
    
    func getProblems(for chapterId: String, languageId: String) async -> [CodingProblem] {
        if FirebaseService.shared.isAvailable {
            // Fetch from Firestore
        }
        return await ProblemDataService.shared.getProblems(for: chapterId, languageId: languageId)
    }
}
