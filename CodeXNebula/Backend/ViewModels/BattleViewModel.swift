//
//  BattleViewModel.swift
//  CodeXNebula
//

import Foundation
import SwiftUI

@MainActor
class BattleViewModel: ObservableObject {
    @Published var friends: [Friend] = []
    @Published var isLoadingFriends: Bool = false
    @Published var battleHistory: [Battle] = []
    
    // Stats
    @Published var totalWins: Int = 0
    @Published var totalBattles: Int = 0
    @Published var currentRank: String = "Neon Knight"
    @Published var battleXP: Int = 0
    
    var winRate: Double {
        guard totalBattles > 0 else { return 0 }
        return Double(totalWins) / Double(totalBattles)
    }
    
    // Settings state
    @Published var availableLanguages: [Language] = []
    @Published var availableChapters: [Chapter] = []
    
    @Published var selectedFriend: Friend?
    @Published var selectedLanguage: Language?
    @Published var selectedChapter: Chapter?
    @Published var selectedDifficulty: ProblemDifficulty = .medium
    @Published var selectedDuration: Int = 10
    
    // Invitation State
    @Published var activeInvitation: BattleInvitation?
    @Published var isSendingInvitation: Bool = false
    
    private let battleService = BattleService()
    
    func loadInitialData() async {
        isLoadingFriends = true
        defer { isLoadingFriends = false }
        
        do {
            async let fetchFriends = battleService.fetchFriends()
            async let fetchHistory = battleService.fetchBattleHistory()
            async let fetchLangs = LearningDataService.shared.getLanguages()
            
            let (friendsResult, historyResult, langs) = try await (fetchFriends, fetchHistory, fetchLangs)
            
            self.friends = friendsResult
            self.battleHistory = historyResult
            self.availableLanguages = langs
            
            if let first = langs.first {
                self.selectedLanguage = first
                await loadChapters(for: first)
            }
            
            if let user = UserStorageService.shared.getCurrentUserSession() {
                self.totalWins = user.battleWins
                self.totalBattles = user.battleWins + user.battleLosses
                self.battleXP = user.battleWins * 150 // Mock logic: 150 XP per win
            }
        } catch {
            AppLogger.error("Failed to load battle data: \(error)")
        }
    }
    
    func loadChapters(for language: Language) async {
        self.selectedLanguage = language
        let chapters = await LearningDataService.shared.getChapters(for: language.id)
        self.availableChapters = chapters
        self.selectedChapter = chapters.first
    }
    
    func sendInvitation(to friend: Friend) async {
        guard let lang = selectedLanguage, let chap = selectedChapter else { return }
        isSendingInvitation = true
        defer { isSendingInvitation = false }
        
        do {
            let invitation = try await battleService.sendInvitation(
                to: friend,
                language: lang,
                chapter: chap,
                difficulty: selectedDifficulty,
                durationMinutes: selectedDuration
            )
            self.activeInvitation = invitation
        } catch {
            AppLogger.error("Failed to send invitation: \(error)")
        }
    }
    
    func cancelInvitation() async {
        guard let invitation = activeInvitation else { return }
        
        do {
            try await battleService.cancelInvitation(invitation.id)
            self.activeInvitation = nil
            self.selectedFriend = nil
        } catch {
            AppLogger.error("Failed to cancel invitation: \(error)")
        }
    }
}
