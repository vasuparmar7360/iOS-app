//
//  AIResponseParser.swift
//  CodeXNebula
//

import Foundation

class AIResponseParser {
    static let shared = AIResponseParser()
    
    private init() {}
    
    func parseTextResponse(from data: Data) throws -> String {
        guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
              let candidates = json["candidates"] as? [[String: Any]],
              let first = candidates.first,
              let content = first["content"] as? [String: Any],
              let parts = content["parts"] as? [[String: Any]],
              let firstPart = parts.first,
              let text = firstPart["text"] as? String else {
            throw AIError.parsingError
        }
        return text
    }
    
    func parseCodeAnalysis(from response: String) throws -> CodeAnalysis {
        return CodeAnalysis(
            correctness: "95%",
            readability: "Good",
            timeComplexity: "O(N)",
            spaceComplexity: "O(1)",
            potentialBugs: ["Consider checking for null values"],
            learningSuggestions: ["Use guard let for safer unwrapping"]
        )
    }
    
    func parseBattleEvaluation(from response: String) throws -> BattleEvaluation {
        let metrics1 = CodeMetrics(correctness: 100, performance: 100, readability: 100, optimization: 100, speed: 100, style: 100)
        let metrics2 = CodeMetrics(correctness: 80, performance: 80, readability: 80, optimization: 80, speed: 80, style: 80)
        return BattleEvaluation(
            id: UUID().uuidString,
            battleId: "placeholder",
            problemTitle: "Placeholder",
            languageId: "swift",
            difficulty: "easy",
            player1Score: PlayerScore(id: "p1", username: "Player 1", code: "", metrics: metrics1, isWinner: true, xpAwarded: 100, estimatedTimeComplexity: "O(1)", estimatedSpaceComplexity: "O(1)", optimizationSuggestions: []),
            player2Score: PlayerScore(id: "p2", username: "Player 2", code: "", metrics: metrics2, isWinner: false, xpAwarded: 10, estimatedTimeComplexity: "O(N)", estimatedSpaceComplexity: "O(N)", optimizationSuggestions: []),
            decision: WinnerDecision(winnerId: "p1", runnerUpId: "p2", victoryReason: "Better performance and readability.", summary: "Player 1's code was perfectly optimized.")
        )
    }
    
    func parseCodingProblem(from response: String) throws -> CodingProblem {
        return CodingProblem(
            id: UUID().uuidString,
            title: "Generated Problem",
            description: "Solve this generated problem.",
            languageId: "swift",
            chapterId: "ch1",
            difficulty: .medium,
            xpReward: 100,
            isCompleted: false,
            constraints: [],
            notes: nil,
            sampleInput: "",
            sampleOutput: "",
            explanation: "",
            starterCode: "",
            estimatedTime: "15 mins",
            tags: []
        )
    }
}
