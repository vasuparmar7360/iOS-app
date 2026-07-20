//
//  GeminiService.swift
//  CodeXNebula
//

import Foundation

enum AIError: Error {
    case invalidResponse
    case networkError
    case rateLimited
    case configurationError
    case parsingError
}

class GeminiService {
    static let shared = GeminiService()
    
    private let apiKey: String
    private let endpoint = "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent"
    
    private init() {
        // Read API key from a secure config file or environment
        if let path = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
           let dict = NSDictionary(contentsOfFile: path) as? [String: Any],
           let key = dict["GEMINI_API_KEY"] as? String {
            self.apiKey = key
        } else {
            self.apiKey = "PLACEHOLDER_DO_NOT_COMMIT"
            AppLogger.info("WARNING: Gemini API Key not found in Secrets.plist")
        }
    }
    
    func generateContent(prompt: String) async throws -> String {
        guard apiKey != "PLACEHOLDER_DO_NOT_COMMIT" else {
            // Mock response if key is missing
            try await Task.sleep(nanoseconds: 1_000_000_000)
            return "This is a simulated AI response because the actual Gemini API key is not configured yet. Set it in Secrets.plist."
        }
        
        try await RateLimiter.shared.waitForToken()
        
        guard let url = URL(string: "\(endpoint)?key=\(apiKey)") else {
            throw AIError.configurationError
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "contents": [
                ["parts": [["text": prompt]]]
            ]
        ]
        
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw AIError.networkError
        }
        
        return try AIResponseParser.shared.parseTextResponse(from: data)
    }
}
