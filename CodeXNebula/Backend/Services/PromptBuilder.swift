//
//  PromptBuilder.swift
//  CodeXNebula
//

import Foundation

class PromptBuilder {
    static let shared = PromptBuilder()
    
    private init() {}
    
    func buildConceptExplanation(concept: String, language: String) -> String {
        return "Explain the programming concept '\(concept)' in \(language). Be concise, use Markdown, and provide a short code example."
    }
    
    func buildHintPrompt(level: Int, problemId: String, code: String) -> String {
        return "I am stuck on problem \(problemId). Here is my code:\n\(code)\nProvide a level \(level) hint. Do NOT give me the final answer. Just point me in the right direction."
    }
    
    func buildCodeReviewPrompt(code: String, language: String) -> String {
        return "Review the following \(language) code and provide feedback on readability, optimization, potential bugs, time complexity, and space complexity:\n\(code)"
    }
    
    func buildBattleJudgePrompt(player1: String, player2: String, problemId: String) -> String {
        return "Evaluate these two submissions for problem \(problemId). Compare them based on correctness, efficiency, and readability. Decide a winner.\nPlayer 1:\n\(player1)\n\nPlayer 2:\n\(player2)"
    }
    
    func buildQuestionGenerationPrompt(language: String, difficulty: ProblemDifficulty) -> String {
        return "Generate a new practice coding question in \(language) with difficulty \(difficulty.rawValue). Provide title, description, starter code, sample input/output, and constraints."
    }
}
