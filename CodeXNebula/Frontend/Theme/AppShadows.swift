//
//  AppShadows.swift
//  CodeXNebula
//
//  Reusable shadow and neon-glow styles for the cyberpunk design system.
//  Use these via the ViewModifier extensions — never write raw shadow() calls.
//

import SwiftUI

// MARK: - Shadow Tokens

enum AppShadow {

    // -------------------------------------------------------------------------
    // MARK: Standard Shadows
    // -------------------------------------------------------------------------

    struct Token {
        let color: Color
        let radius: CGFloat
        let x: CGFloat
        let y: CGFloat
    }

    /// Subtle depth shadow for cards.
    static let card = Token(
        color: Color.black.opacity(0.45),
        radius: 16,
        x: 0,
        y: 8
    )

    /// Medium elevation shadow for floating elements.
    static let medium = Token(
        color: Color.black.opacity(0.35),
        radius: 10,
        x: 0,
        y: 4
    )

    /// Heavy shadow for modals and bottom sheets.
    static let modal = Token(
        color: Color.black.opacity(0.6),
        radius: 28,
        x: 0,
        y: 12
    )

    // -------------------------------------------------------------------------
    // MARK: Neon Glow Shadows
    // -------------------------------------------------------------------------

    /// Cyan neon glow — primary interactive elements.
    static let neonCyan = Token(
        color: AppColors.neonCyan.opacity(0.45),
        radius: 18,
        x: 0,
        y: 0
    )

    /// Purple neon glow — XP, level, secondary elements.
    static let neonPurple = Token(
        color: AppColors.neonPurple.opacity(0.45),
        radius: 18,
        x: 0,
        y: 0
    )

    /// Blue neon glow — links, code keywords.
    static let neonBlue = Token(
        color: AppColors.blueAccent.opacity(0.40),
        radius: 16,
        x: 0,
        y: 0
    )

    /// Success glow — correct answers, completed states.
    static let neonSuccess = Token(
        color: AppColors.success.opacity(0.40),
        radius: 16,
        x: 0,
        y: 0
    )

    /// Warning glow — alerts, time limits.
    static let neonWarning = Token(
        color: AppColors.warning.opacity(0.40),
        radius: 16,
        x: 0,
        y: 0
    )

    // -------------------------------------------------------------------------
    // MARK: Button Shadow
    // -------------------------------------------------------------------------

    /// Directional shadow specifically for buttons.
    static let button = Token(
        color: AppColors.neonCyan.opacity(0.30),
        radius: 12,
        x: 0,
        y: 4
    )
}

// MARK: - Shadow ViewModifiers

struct CardShadowModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .shadow(
                color: AppShadow.card.color,
                radius: AppShadow.card.radius,
                x: AppShadow.card.x,
                y: AppShadow.card.y
            )
    }
}

struct NeonGlowModifier: ViewModifier {
    let token: AppShadow.Token
    let intensity: Double

    func body(content: Content) -> some View {
        content
            .shadow(
                color: token.color.opacity(intensity),
                radius: token.radius * 0.6,
                x: token.x,
                y: token.y
            )
            .shadow(
                color: token.color.opacity(intensity * 0.5),
                radius: token.radius,
                x: token.x,
                y: token.y
            )
    }
}

// MARK: - View Extensions

extension View {

    /// Applies the standard card shadow.
    func cardShadow() -> some View {
        modifier(CardShadowModifier())
    }

    /// Applies a double-layered neon glow effect.
    func neonGlow(_ token: AppShadow.Token, intensity: Double = 1.0) -> some View {
        modifier(NeonGlowModifier(token: token, intensity: intensity))
    }

    /// Convenience — cyan neon glow.
    func cyanGlow(intensity: Double = 1.0) -> some View {
        neonGlow(AppShadow.neonCyan, intensity: intensity)
    }

    /// Convenience — purple neon glow.
    func purpleGlow(intensity: Double = 1.0) -> some View {
        neonGlow(AppShadow.neonPurple, intensity: intensity)
    }
}
