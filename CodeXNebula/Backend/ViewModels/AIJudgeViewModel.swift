//
//  AIJudgeViewModel.swift
//  CodeXNebula
//

import Foundation
import SwiftUI

@MainActor
class AIJudgeViewModel: ObservableObject {
    @Published var isLoading: Bool = true
    @Published var evaluation: BattleEvaluation?
    
    private let judgeService = AIJudgeService()
    
    func generateEvaluation(player1Code: String, player2Code: String) async {
        isLoading = true
        do {
            let result = try await judgeService.evaluateBattle(player1Code: player1Code, player2Code: player2Code)
            self.evaluation = result
        } catch {
            AppLogger.error("AI Judge Evaluation Failed: \(error)")
        }
        isLoading = false
    }
}
