//
//  CodeSubmission.swift
//  CodeXNebula
//
//  Represents a user's code submission.
//

import Foundation

struct CodeSubmission: Identifiable, Codable {
    let id: String
    let problemId: String
    let userId: String
    let languageId: String
    let code: String
    let timestamp: Date
    let result: ExecutionResult?
    
    init(id: String = UUID().uuidString, problemId: String, userId: String, languageId: String, code: String, timestamp: Date = Date(), result: ExecutionResult? = nil) {
        self.id = id
        self.problemId = problemId
        self.userId = userId
        self.languageId = languageId
        self.code = code
        self.timestamp = timestamp
        self.result = result
    }
}
