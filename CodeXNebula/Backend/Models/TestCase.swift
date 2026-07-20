//
//  TestCase.swift
//  CodeXNebula
//
//  Represents a single test case for code execution.
//

import Foundation

struct TestCase: Identifiable, Codable {
    let id: String
    let input: String
    let expectedOutput: String
    let explanation: String?
    
    init(id: String = UUID().uuidString, input: String, expectedOutput: String, explanation: String? = nil) {
        self.id = id
        self.input = input
        self.expectedOutput = expectedOutput
        self.explanation = explanation
    }
}
