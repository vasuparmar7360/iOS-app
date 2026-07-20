//
//  ExecutionResult.swift
//  CodeXNebula
//
//  Represents the result of running or submitting code.
//

import Foundation
import SwiftUI

enum ExecutionStatus: String, Codable {
    case pending = "Pending"
    case running = "Running"
    case accepted = "Accepted"
    case wrongAnswer = "Wrong Answer"
    case compilationError = "Compilation Error"
    case runtimeError = "Runtime Error"
    case timeLimitExceeded = "Time Limit Exceeded"
    case memoryLimitExceeded = "Memory Limit Exceeded"
    
    var color: Color {
        switch self {
        case .accepted:
            return AppColors.success
        case .wrongAnswer, .compilationError, .runtimeError, .timeLimitExceeded, .memoryLimitExceeded:
            return AppColors.error
        case .pending, .running:
            return AppColors.warning
        }
    }
}

struct ExecutionResult: Codable {
    let status: ExecutionStatus
    let executionTimeMs: Double
    let memoryUsageKB: Double
    let passedTestCases: Int
    let totalTestCases: Int
    let output: String
    let errorMessage: String?
    let xpEarned: Int
    
    init(status: ExecutionStatus, executionTimeMs: Double, memoryUsageKB: Double, passedTestCases: Int, totalTestCases: Int, output: String, errorMessage: String? = nil, xpEarned: Int) {
        self.status = status
        self.executionTimeMs = executionTimeMs
        self.memoryUsageKB = memoryUsageKB
        self.passedTestCases = passedTestCases
        self.totalTestCases = totalTestCases
        self.output = output
        self.errorMessage = errorMessage
        self.xpEarned = xpEarned
    }
}
