//
//  BattleArenaViewModel.swift
//  CodeXNebula
//

import Foundation
import SwiftUI
import Combine

enum ArenaState {
    case loading
    case playing
    case submitting
    case waitingForOpponent
    case finished
}

@MainActor
class BattleArenaViewModel: ObservableObject {
    @Published var state: ArenaState = .loading
    
    // Battle Data
    @Published var opponentUsername: String
    @Published var playerUsername: String = "You"
    @Published var language: Language
    @Published var chapter: Chapter
    @Published var difficulty: ProblemDifficulty
    
    // Problem & Code
    @Published var problem: BattleProblem?
    @Published var code: String = ""
    @Published var opponentCode: String = ""
    @Published var executionResult: ExecutionResult?
    
    // Timer
    @Published var timer: BattleTimer
    private var timerCancellable: AnyCancellable?
    
    // Results
    @Published var battleResult: BattleResult?
    @Published var opponentStatus: String = "Opponent is Coding..."
    
    // Flags
    @Published var isRunningCode: Bool = false
    
    private let engineService = BattleEngineService()
    
    init(opponent: Friend, language: Language, chapter: Chapter, difficulty: ProblemDifficulty, durationMinutes: Int) {
        self.opponentUsername = opponent.username
        self.language = language
        self.chapter = chapter
        self.difficulty = difficulty
        let totalSecs = durationMinutes * 60
        self.timer = BattleTimer(remainingSeconds: totalSecs, totalSeconds: totalSecs)
    }
    
    func startBattle() async {
        state = .loading
        do {
            let fetchedProblem = try await engineService.fetchBattleProblem(for: language.id, chapterId: chapter.id, difficulty: difficulty)
            self.problem = fetchedProblem
            self.code = fetchedProblem.starterCode
            self.state = .playing
            startTimer()
        } catch {
            AppLogger.error("Failed to load problem: \(error)")
        }
    }
    
    private func startTimer() {
        timerCancellable = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                if self.timer.remainingSeconds > 0 {
                    self.timer.remainingSeconds -= 1
                } else {
                    self.timerCancellable?.cancel()
                    if self.state == .playing {
                        Task { await self.submitCode() }
                    }
                }
            }
    }
    
    func runCode() async {
        guard !code.isEmpty else { return }
        isRunningCode = true
        defer { isRunningCode = false }
        
        do {
            self.executionResult = try await engineService.runCode(code, languageId: language.id)
        } catch {
            AppLogger.error("Failed to run code: \(error)")
        }
    }
    
    func submitCode() async {
        state = .submitting
        timerCancellable?.cancel()
        
        do {
            _ = try await engineService.submitSolution(code, playerId: "currentUser")
            
            state = .waitingForOpponent
            
            // Poll opponent status in a real app, here we just fake it
            self.opponentStatus = try await engineService.getOpponentStatus()
            self.opponentCode = "// Opponent's submitted solution\nfunc solve() {\n    return 42\n}"
            
            // Then move to results
            try await Task.sleep(nanoseconds: 2_000_000_000)
            generateMockResult()
        } catch {
            AppLogger.error("Failed to submit code: \(error)")
            state = .playing // revert if error
        }
    }
    
    func resetCode() {
        guard let p = problem else { return }
        self.code = p.starterCode
        self.executionResult = nil
    }
    
    private func generateMockResult() {
        self.battleResult = BattleResult(
            id: UUID().uuidString,
            winnerId: "currentUser",
            runnerUpId: "opponentId",
            xpEarned: difficulty.xpReward * 2,
            baseBattleXp: difficulty.xpReward,
            completionTimeSeconds: timer.totalSeconds - timer.remainingSeconds,
            status: "Victory",
            accuracyPercentage: 100.0
        )
        self.state = .finished
    }
    
    func exitBattle() {
        timerCancellable?.cancel()
    }
}
