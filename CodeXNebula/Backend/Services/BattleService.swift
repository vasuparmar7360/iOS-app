//
//  BattleService.swift
//  CodeXNebula
//

import Foundation

class BattleService {
    func fetchFriends() async throws -> [Friend] {
        try await Task.sleep(nanoseconds: 500_000_000)
        return Friend.dummyFriends
    }
    
    func fetchBattleHistory() async throws -> [Battle] {
        try await Task.sleep(nanoseconds: 300_000_000)
        return Battle.dummyHistory
    }
    
    func sendInvitation(to friend: Friend, language: Language, chapter: Chapter, difficulty: ProblemDifficulty, durationMinutes: Int) async throws -> BattleInvitation {
        try await Task.sleep(nanoseconds: 800_000_000)
        // Dummy matchmaking logic: just assign a dummy problem ID
        let dummyProblemId = "\(language.id)_\(chapter.id)_\(difficulty.rawValue)"
        
        return BattleInvitation(
            id: UUID().uuidString,
            senderId: "currentUser",
            receiverId: friend.id,
            problemId: dummyProblemId,
            languageId: language.id,
            durationMinutes: durationMinutes,
            expiresAt: Date().addingTimeInterval(300) // 5 minutes to accept
        )
    }
    
    func cancelInvitation(_ invitationId: String) async throws {
        try await Task.sleep(nanoseconds: 400_000_000)
    }
}
