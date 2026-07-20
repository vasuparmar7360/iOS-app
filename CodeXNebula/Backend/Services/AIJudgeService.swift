//
//  AIJudgeService.swift
//  CodeXNebula
//

import Foundation

class AIJudgeService {
    
    // Future integrations for Gemini, OpenAI, Claude can be added here
    
    func evaluateBattle(player1Code: String, player2Code: String) async throws -> BattleEvaluation {
        try await Task.sleep(nanoseconds: 2_500_000_000)
        
        let p1Metrics = CodeMetrics(correctness: 40, performance: 18, readability: 12, optimization: 15, speed: 10, style: 5)
        let p2Metrics = CodeMetrics(correctness: 35, performance: 12, readability: 10, optimization: 10, speed: 8, style: 4)
        
        let p1 = PlayerScore(
            id: "currentUser",
            username: "You",
            code: player1Code,
            metrics: p1Metrics,
            isWinner: true,
            xpAwarded: 100, // Winner XP
            estimatedTimeComplexity: "O(N)",
            estimatedSpaceComplexity: "O(1)",
            optimizationSuggestions: ["Excellent use of native Swift functions.", "Clean variable naming."]
        )
        
        let p2 = PlayerScore(
            id: "opponentId",
            username: "Opponent",
            code: player2Code,
            metrics: p2Metrics,
            isWinner: false,
            xpAwarded: 40, // Runner up XP
            estimatedTimeComplexity: "O(N^2)",
            estimatedSpaceComplexity: "O(N)",
            optimizationSuggestions: ["Avoid nested loops to improve time complexity.", "Use a dictionary for O(1) lookups."]
        )
        
        let decision = WinnerDecision(
            winnerId: "currentUser",
            runnerUpId: "opponentId",
            victoryReason: "You solved the problem faster with better code readability and lower estimated time complexity.",
            summary: "A decisive victory driven by strong algorithmic efficiency."
        )
        
        return BattleEvaluation(
            id: UUID().uuidString,
            battleId: "dummy_battle",
            problemTitle: "Cyber Array Sum",
            languageId: "swift",
            difficulty: "Medium",
            player1Score: p1,
            player2Score: p2,
            decision: decision
        )
    }
}
