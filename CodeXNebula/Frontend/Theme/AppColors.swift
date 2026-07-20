//
//  AppColors.swift
//  CodeXNebula
//
//  Centralised cyberpunk colour palette.
//  All values tuned for dark mode. Never hardcode colours elsewhere.
//

import SwiftUI

// MARK: - AppColors

enum AppColors {

    // -------------------------------------------------------------------------
    // MARK: Backgrounds
    // -------------------------------------------------------------------------

    /// Deep space — primary app canvas.
    static let background        = Color(hex: "#070B14")

    /// Slightly elevated surface for sections and lists.
    static let backgroundSecondary = Color(hex: "#0D1117")

    /// Card background — elevated glass-style dark.
    static let cardBackground    = Color(hex: "#111827")

    /// Translucent glass layer — used with `.ultraThinMaterial` blur.
    static let glassBackground   = Color(hex: "#1A2035").opacity(0.72)

    // -------------------------------------------------------------------------
    // MARK: Neon Accents
    // -------------------------------------------------------------------------

    /// Neon cyan — primary interactive accent.
    static let neonCyan          = Color(hex: "#00F5FF")

    /// Neon purple — secondary accent / XP / levelling.
    static let neonPurple        = Color(hex: "#BF5FFF")

    /// Electric blue — highlights, links, code keywords.
    static let blueAccent        = Color(hex: "#4D9FFF")

    // -------------------------------------------------------------------------
    // MARK: Semantic
    // -------------------------------------------------------------------------

    static let success           = Color(hex: "#00FF88")
    static let warning           = Color(hex: "#FFB800")
    static let error             = Color(hex: "#FF3860")

    // -------------------------------------------------------------------------
    // MARK: Text
    // -------------------------------------------------------------------------

    static let textPrimary       = Color(hex: "#FFFFFF")
    static let textSecondary     = Color(hex: "#8892A4")
    static let textTertiary      = Color(hex: "#4A5568")

    // -------------------------------------------------------------------------
    // MARK: Dividers / Borders
    // -------------------------------------------------------------------------

    static let divider           = Color(hex: "#1E2D4A")
    static let borderSubtle      = Color(hex: "#243047")

    // -------------------------------------------------------------------------
    // MARK: Gradient Shorthands
    // -------------------------------------------------------------------------

    /// Cyan → Purple — primary branded gradient.
    static let gradientPrimary = LinearGradient(
        colors: [neonCyan, neonPurple],
        startPoint: .leading,
        endPoint: .trailing
    )

    /// Purple → Blue — secondary gradient for XP/level elements.
    static let gradientXP = LinearGradient(
        colors: [neonPurple, blueAccent],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    /// Cyan glow — used on neon buttons and active states.
    static let gradientCyan = LinearGradient(
        colors: [neonCyan.opacity(0.9), blueAccent],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    /// Dark card gradient — subtle depth.
    static let gradientCard = LinearGradient(
        colors: [cardBackground, backgroundSecondary],
        startPoint: .top,
        endPoint: .bottom
    )

    /// Success gradient — used on completion states.
    static let gradientSuccess = LinearGradient(
        colors: [success, neonCyan.opacity(0.7)],
        startPoint: .leading,
        endPoint: .trailing
    )
}

// MARK: - Color + Hex Initialiser

extension Color {
    /// Create a `Color` from a CSS hex string (#RRGGBB or #AARRGGBB).
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red:   Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
