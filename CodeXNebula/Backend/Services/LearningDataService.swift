//
//  LearningDataService.swift
//  CodeXNebula
//
//  Mock service providing learning content.
//

import Foundation

class LearningDataService {
    static let shared = LearningDataService()
    
    private init() {}
    
    func getLanguages() async -> [Language] {
        return [
            Language(id: "cpp", name: "C++", iconName: "curlybraces", totalProblems: 120, completedProblems: 30),
            Language(id: "python", name: "Python", iconName: "terminal", totalProblems: 150, completedProblems: 0),
            Language(id: "java", name: "Java", iconName: "cup.and.saucer", totalProblems: 140, completedProblems: 0),
            Language(id: "swift", name: "Swift", iconName: "swift", totalProblems: 100, completedProblems: 15),
            Language(id: "c", name: "C", iconName: "c.square", totalProblems: 80, completedProblems: 0)
        ]
    }
    
    func getChapters(for languageId: String) async -> [Chapter] {
        return await ProblemDataService.shared.getChapters(for: languageId)
    }
    
    func getProblems(for chapterId: String, languageId: String) async -> [CodingProblem] {
        return await ProblemDataService.shared.getProblems(for: chapterId, languageId: languageId)
    }
}
