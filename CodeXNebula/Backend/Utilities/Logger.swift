//
//  Logger.swift
//  CodeXNebula
//
//  Lightweight structured logger wrapping OSLog.
//  Usage: AppLogger.info("Message")
//

import Foundation
import OSLog

enum AppLogger {

    private static let subsystem = Bundle.main.bundleIdentifier ?? AppConstants.bundleID

    private static let general  = Logger(subsystem: subsystem, category: "General")
    private static let network  = Logger(subsystem: subsystem, category: "Network")
    private static let ui       = Logger(subsystem: subsystem, category: "UI")
    private static let auth     = Logger(subsystem: subsystem, category: "Auth")

    // MARK: - Public API

    static func info(_ message: String, category: Category = .general) {
        logger(for: category).info("\(message, privacy: .public)")
    }

    static func debug(_ message: String, category: Category = .general) {
        logger(for: category).debug("\(message, privacy: .public)")
    }

    static func warning(_ message: String, category: Category = .general) {
        logger(for: category).warning("\(message, privacy: .public)")
    }

    static func error(_ message: String, category: Category = .general) {
        logger(for: category).error("\(message, privacy: .public)")
    }

    // MARK: - Category

    enum Category {
        case general, network, ui, auth
    }

    private static func logger(for category: Category) -> Logger {
        switch category {
        case .general: return general
        case .network: return network
        case .ui:      return ui
        case .auth:    return auth
        }
    }
}
