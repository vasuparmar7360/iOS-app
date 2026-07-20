import Foundation

enum AIMessageRole: String, Codable {
    case user
    case neo
}

struct AIMessage: Identifiable, Codable, Hashable {
    let id: String
    let role: AIMessageRole
    let content: String
    let timestamp: Date
    
    init(id: String = UUID().uuidString, role: AIMessageRole, content: String, timestamp: Date = Date()) {
        self.id = id
        self.role = role
        self.content = content
        self.timestamp = timestamp
    }
}
