//
//  ConversationManager.swift
//  CodeXNebula
//

import Foundation

class ConversationManager {
    static let shared = ConversationManager()
    
    private var history: [AIMessage] = []
    
    private init() {}
    
    func addMessage(_ message: AIMessage) {
        history.append(message)
    }
    
    func getHistory() -> [AIMessage] {
        return history
    }
    
    func clearHistory() {
        history.removeAll()
    }
    
    func getContextPrompt() -> String {
        return history.map { "\($0.role == .user ? "User" : "Neo"): \($0.content)" }.joined(separator: "\n")
    }
}
