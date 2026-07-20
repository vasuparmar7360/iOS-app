//
//  CodeExecutionService.swift
//  CodeXNebula
//
//  Service to handle code execution via placeholder API.
//

import Foundation

class CodeExecutionService {
    static let shared = CodeExecutionService()
    
    private init() {}
    
    /// Executes the provided code and returns a placeholder result.
    func executeCode(code: String, language: String, problemId: String) async throws -> ExecutionResult {
        // Placeholder for Judge0, Custom Compiler, or Cloud Execution Service
        // Simulating network delay
        try await Task.sleep(nanoseconds: 1_500_000_000)
        
        // Mocking a successful response for demonstration
        return ExecutionResult(
            status: .accepted,
            executionTimeMs: Double.random(in: 1.0...10.0),
            memoryUsageKB: Double.random(in: 1024.0...4096.0),
            passedTestCases: 5,
            totalTestCases: 5,
            output: "Program executed successfully.\nOutput matches expected result.",
            errorMessage: nil,
            xpEarned: 50 // Will be overridden by the ViewModel with the actual problem XP
        )
    }
}
