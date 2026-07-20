//
//  RateLimiter.swift
//  CodeXNebula
//

import Foundation

actor RateLimiter {
    static let shared = RateLimiter()
    
    private var lastRequestTime: Date = Date.distantPast
    private let minInterval: TimeInterval = 2.0 // 2 seconds between requests
    
    private init() {}
    
    func waitForToken() async throws {
        let now = Date()
        let elapsed = now.timeIntervalSince(lastRequestTime)
        if elapsed < minInterval {
            let delay = minInterval - elapsed
            try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
        }
        lastRequestTime = Date()
    }
}
