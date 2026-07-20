//
//  BattleSessionManager.swift
//  CodeXNebula
//

import Foundation
import Combine

@MainActor
class BattleSessionManager: ObservableObject {
    static let shared = BattleSessionManager()
    
    @Published var currentSession: BattleSession?
    @Published var connectionState: ConnectionState = .disconnected
    
    enum ConnectionState {
        case connected, disconnected, connecting, error
    }
    
    private init() {}
    
    func joinSession(_ sessionId: String) async throws {
        self.connectionState = .connecting
        // Connect to Firestore realtime listener
        
        // Mock fallback
        self.currentSession = BattleSession(
            id: sessionId,
            problemId: "swift_ch1_e",
            languageId: "swift",
            player1Id: "player1",
            player2Id: "player2",
            state: .waiting,
            player1Ready: false,
            player2Ready: false,
            player1Submitted: false,
            player2Submitted: false
        )
        self.connectionState = .connected
    }
    
    func leaveSession() async {
        self.currentSession = nil
        self.connectionState = .disconnected
    }
}
