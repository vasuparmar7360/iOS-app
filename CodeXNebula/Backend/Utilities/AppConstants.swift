//
//  AppConstants.swift
//  CodeXNebula
//
//  Global constants used across the application.
//

import Foundation

enum AppConstants {

    // MARK: - App Info
    static let appName        = "CodeX Nebula"
    static let appVersion     = "1.0.0"
    static let buildNumber    = "1"
    static let bundleID       = "com.codexnebula.app"

    // MARK: - API (placeholders — fill in when backend is ready)
    static let baseURL        = "https://api.codexnebula.app"
    static let apiVersion     = "v1"

    // MARK: - Storage Keys
    enum Keys {
        static let authToken      = "auth_token"
        static let userID         = "user_id"
        static let onboardingDone = "onboarding_complete"
    }

    // MARK: - Timing
    static let animationDuration: Double = 0.3
    static let splashDuration: Double    = 2.0
}
