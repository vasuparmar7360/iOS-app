//
//  CodingViewModel.swift
//  CodeXNebula
//
//  ViewModel for managing the Code Editor, execution state, and drafts.
//

import SwiftUI
import Combine

@MainActor
class CodingViewModel: ObservableObject {
    @Published var code: String = ""
    @Published var isRunning: Bool = false
    @Published var isSubmitting: Bool = false
    @Published var executionResult: ExecutionResult? = nil
    @Published var showResult: Bool = false
    
    let problem: CodingProblem
    let language: Language
    
    init(problem: CodingProblem, language: Language) {
        self.problem = problem
        self.language = language
        loadDraft()
    }
    
    func loadStarterCode() {
        if let customCode = problem.starterCode {
            code = customCode
            return
        }
        
        switch language.id.lowercased() {
        case "cpp", "c++":
            code = "#include <iostream>\nusing namespace std;\n\nint main() {\n    // Write your code here\n    return 0;\n}"
        case "python":
            code = "def main():\n    # Write your code here\n    pass\n\nif __name__ == \"__main__\":\n    main()"
        case "java":
            code = "public class Main {\n    public static void main(String[] args) {\n        // Write your code here\n    }\n}"
        case "swift":
            code = "import Foundation\n\n// Write your code here\nprint(\"Hello, CodeX Nebula!\")"
        case "c":
            code = "#include <stdio.h>\n\nint main() {\n    // Write your code here\n    return 0;\n}"
        default:
            code = "// Write your code here"
        }
    }
    
    private var draftKey: String {
        return "draft_\(language.id)_\(problem.id)"
    }
    
    func saveDraft() {
        UserDefaults.standard.set(code, forKey: draftKey)
    }
    
    func loadDraft() {
        if let draft = UserDefaults.standard.string(forKey: draftKey), !draft.isEmpty {
            code = draft
        } else {
            loadStarterCode()
        }
    }
    
    func resetCode() {
        loadStarterCode()
        saveDraft()
    }
    
    func runCode() async {
        isRunning = true
        executionResult = nil
        do {
            let result = try await CodeExecutionService.shared.executeCode(code: code, language: language.id, problemId: problem.id)
            self.executionResult = result
        } catch {
            self.executionResult = ExecutionResult(status: .runtimeError, executionTimeMs: 0, memoryUsageKB: 0, passedTestCases: 0, totalTestCases: 0, output: "", errorMessage: error.localizedDescription, xpEarned: 0)
        }
        isRunning = false
    }
    
    func submitSolution() async {
        isSubmitting = true
        executionResult = nil
        do {
            var result = try await CodeExecutionService.shared.executeCode(code: code, language: language.id, problemId: problem.id)
            // Adjust XP based on difficulty
            result = ExecutionResult(
                status: result.status,
                executionTimeMs: result.executionTimeMs,
                memoryUsageKB: result.memoryUsageKB,
                passedTestCases: result.passedTestCases,
                totalTestCases: result.totalTestCases,
                output: result.output,
                errorMessage: result.errorMessage,
                xpEarned: problem.xpReward
            )
            self.executionResult = result
            self.showResult = true
            
            // If accepted, update user progress
            if result.status == .accepted {
                if var user = UserStorageService.shared.getCurrentUserSession() {
                    if !user.completedProblems.contains(problem.id) {
                        user.completedProblems.append(problem.id)
                        user.xp += problem.xpReward
                        user.level = (user.xp / 500) + 1
                        UserStorageService.shared.saveUser(user)
                        UserStorageService.shared.saveCurrentUserSession(user)
                    }
                }
            }
            
        } catch {
            self.executionResult = ExecutionResult(status: .runtimeError, executionTimeMs: 0, memoryUsageKB: 0, passedTestCases: 0, totalTestCases: 0, output: "", errorMessage: error.localizedDescription, xpEarned: 0)
            self.showResult = true
        }
        isSubmitting = false
    }
}
