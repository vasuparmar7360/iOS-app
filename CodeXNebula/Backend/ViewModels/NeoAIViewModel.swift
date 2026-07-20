import SwiftUI

@MainActor
class NeoAIViewModel: ObservableObject {
    @Published var messages: [AIMessage] = []
    @Published var isTyping: Bool = false
    
    private let service = NeoAIService.shared
    
    let problem: CodingProblem
    
    init(problem: CodingProblem) {
        self.problem = problem
        
        // Initial greeting
        messages.append(AIMessage(role: .neo, content: "Hello, I am NEO. Your AI coding mentor. How can I assist you with '\(problem.title)' today?"))
    }
    
    func addUserMessage(_ text: String) {
        let msg = AIMessage(role: .user, content: text)
        messages.append(msg)
    }
    
    private func addNeoMessage(_ text: String) {
        let msg = AIMessage(role: .neo, content: text)
        messages.append(msg)
    }
    
    func requestHint(code: String, appState: AppState) async {
        guard let user = appState.currentUser else { return }
        if user.xp < 10 {
            addNeoMessage("You don't have enough XP for a hint. Keep solving problems to earn more XP!")
            return
        }
        
        // Deduct XP
        var updatedUser = user
        updatedUser.xp -= 10
        appState.currentUser = updatedUser
        
        addUserMessage("Can you give me a hint?")
        isTyping = true
        
        do {
            let result = try await service.getHint(for: problem.id, currentCode: code)
            isTyping = false
            
            let fullMessage = "\(result.message)\n\n**You learned:**\n\(result.conceptsLearned.map { "• \($0)" }.joined(separator: "\n"))"
            addNeoMessage(fullMessage)
        } catch {
            isTyping = false
            addNeoMessage("I'm having trouble analyzing your code right now. Try again later.")
        }
    }
    
    func requestExplanation() async {
        addUserMessage("Can you explain the problem?")
        isTyping = true
        
        do {
            let explanation = try await service.explainProblem(for: problem.id)
            isTyping = false
            addNeoMessage(explanation)
        } catch {
            isTyping = false
            addNeoMessage("I couldn't generate an explanation at this moment.")
        }
    }
    
    func requestCodeReview(code: String, languageId: String) async {
        addUserMessage("Can you review my code?")
        isTyping = true
        
        do {
            let analysis = try await service.reviewCode(code: code, language: languageId)
            isTyping = false
            
            var reviewText = "**Code Review:**\n"
            reviewText += "\n**Correctness:** \(analysis.correctness)"
            reviewText += "\n**Readability:** \(analysis.readability)"
            reviewText += "\n**Time Complexity:** \(analysis.timeComplexity)"
            reviewText += "\n**Space Complexity:** \(analysis.spaceComplexity)"
            
            if !analysis.potentialBugs.isEmpty {
                reviewText += "\n\n**Potential Bugs:**"
                for bug in analysis.potentialBugs {
                    reviewText += "\n• \(bug)"
                }
            }
            
            if !analysis.learningSuggestions.isEmpty {
                reviewText += "\n\n**Suggestions for Learning:**"
                for suggestion in analysis.learningSuggestions {
                    reviewText += "\n• \(suggestion)"
                }
            }
            
            addNeoMessage(reviewText)
        } catch {
            isTyping = false
            addNeoMessage("I encountered an issue while reviewing your code.")
        }
    }
    
    func requestBugFind(code: String, languageId: String) async {
        addUserMessage("Can you find any bugs in my code?")
        isTyping = true
        
        do {
            let bugs = try await service.findBugs(code: code, language: languageId)
            isTyping = false
            addNeoMessage(bugs)
        } catch {
            isTyping = false
            addNeoMessage("Failed to find bugs.")
        }
    }
    
    func requestOptimization(code: String, languageId: String) async {
        addUserMessage("How can I optimize this?")
        isTyping = true
        
        do {
            let optimization = try await service.optimizeCode(code: code, language: languageId)
            isTyping = false
            addNeoMessage(optimization)
        } catch {
            isTyping = false
            addNeoMessage("Failed to generate optimization advice.")
        }
    }
    
    func requestTimeComplexity(code: String) async {
        addUserMessage("What is the time complexity?")
        isTyping = true
        do {
            let resp = try await service.explainTimeComplexity(code: code)
            isTyping = false
            addNeoMessage(resp)
        } catch {
            isTyping = false
            addNeoMessage("Failed to analyze time complexity.")
        }
    }
    
    func requestSpaceComplexity(code: String) async {
        addUserMessage("What is the space complexity?")
        isTyping = true
        do {
            let resp = try await service.explainSpaceComplexity(code: code)
            isTyping = false
            addNeoMessage(resp)
        } catch {
            isTyping = false
            addNeoMessage("Failed to analyze space complexity.")
        }
    }
    
    func requestLearningSuggestions(code: String) async {
        addUserMessage("What should I learn next?")
        isTyping = true
        do {
            let resp = try await service.getLearningSuggestions(code: code)
            isTyping = false
            addNeoMessage(resp)
        } catch {
            isTyping = false
            addNeoMessage("Failed to generate learning suggestions.")
        }
    }
}
