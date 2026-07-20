//
//  NeoAIEngine.swift
//  CodeXNebula
//

import Foundation

class NeoAIEngine {
    static let shared = NeoAIEngine()
    
    private init() {}
    
    func explainConcept(_ concept: String, language: String) async throws -> String {
        let prompt = PromptBuilder.shared.buildConceptExplanation(concept: concept, language: language)
        return try await GeminiService.shared.generateContent(prompt: prompt)
    }
    
    func generateHint(level: Int, problemId: String, code: String) async throws -> String {
        let prompt = PromptBuilder.shared.buildHintPrompt(level: level, problemId: problemId, code: code)
        return try await GeminiService.shared.generateContent(prompt: prompt)
    }
    
    func reviewCode(_ code: String, language: String) async throws -> CodeAnalysis {
        let prompt = PromptBuilder.shared.buildCodeReviewPrompt(code: code, language: language)
        let response = try await GeminiService.shared.generateContent(prompt: prompt)
        return try AIResponseParser.shared.parseCodeAnalysis(from: response)
    }
    
    func judgeBattle(player1Code: String, player2Code: String, problemId: String) async throws -> BattleEvaluation {
        let prompt = PromptBuilder.shared.buildBattleJudgePrompt(player1: player1Code, player2: player2Code, problemId: problemId)
        let response = try await GeminiService.shared.generateContent(prompt: prompt)
        return try AIResponseParser.shared.parseBattleEvaluation(from: response)
    }
    
    func generatePracticeQuestion(language: String, difficulty: ProblemDifficulty) async throws -> CodingProblem {
        let prompt = PromptBuilder.shared.buildQuestionGenerationPrompt(language: language, difficulty: difficulty)
        let response = try await GeminiService.shared.generateContent(prompt: prompt)
        return try AIResponseParser.shared.parseCodingProblem(from: response)
    }
}
