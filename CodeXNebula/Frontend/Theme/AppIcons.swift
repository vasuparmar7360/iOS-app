//
//  AppIcons.swift
//  CodeXNebula
//
//  Centralised SF Symbol icon definitions.
//  Use AppIcon.name everywhere — never write raw system image strings.
//

import SwiftUI

// MARK: - AppIcon Registry

enum AppIcon {

    // -------------------------------------------------------------------------
    // MARK: Navigation / Tab Bar
    // -------------------------------------------------------------------------

    static let home          = "house.fill"
    static let profile       = "person.crop.circle.fill"
    static let leaderboard   = "trophy.fill"
    static let friends       = "person.2.fill"
    static let settings      = "gearshape.fill"

    // -------------------------------------------------------------------------
    // MARK: Coding / Learning
    // -------------------------------------------------------------------------

    static let code          = "chevron.left.forwardslash.chevron.right"
    static let terminal      = "terminal.fill"
    static let mission       = "target"
    static let problem       = "doc.text.fill"
    static let challenge     = "bolt.fill"
    static let hint          = "lightbulb.fill"
    static let run           = "play.fill"
    static let submit        = "checkmark.circle.fill"
    static let reset         = "arrow.counterclockwise"

    // -------------------------------------------------------------------------
    // MARK: AI / Intelligence
    // -------------------------------------------------------------------------

    static let ai            = "cpu.fill"
    static let aiChat        = "bubble.left.and.bubble.right.fill"
    static let sparkle       = "sparkles"
    static let brain         = "brain.filled.head.profile"

    // -------------------------------------------------------------------------
    // MARK: Gamification
    // -------------------------------------------------------------------------

    static let trophy        = "trophy.fill"
    static let medal         = "medal.fill"
    static let star          = "star.fill"
    static let xp            = "bolt.circle.fill"
    static let level         = "chart.bar.fill"
    static let streak        = "flame.fill"
    static let battle        = "shield.lefthalf.filled"
    static let rank          = "crown.fill"

    // -------------------------------------------------------------------------
    // MARK: Actions
    // -------------------------------------------------------------------------

    static let close         = "xmark"
    static let back          = "chevron.left"
    static let forward       = "chevron.right"
    static let add           = "plus"
    static let share         = "square.and.arrow.up"
    static let search        = "magnifyingglass"
    static let filter        = "line.3.horizontal.decrease.circle"
    static let bookmark      = "bookmark.fill"
    static let lock          = "lock.fill"
    static let unlock        = "lock.open.fill"
    static let copy          = "doc.on.doc.fill"

    // -------------------------------------------------------------------------
    // MARK: Status
    // -------------------------------------------------------------------------

    static let checkmark     = "checkmark.circle.fill"
    static let warning       = "exclamationmark.triangle.fill"
    static let info          = "info.circle.fill"
    static let errorIcon     = "xmark.circle.fill"
    static let loading       = "arrow.trianglehead.2.clockwise.rotate.90"
}

// MARK: - AppIconView

/// A consistently-styled SF Symbol icon.
struct AppIconView: View {
    let symbol: String
    var size: CGFloat      = 22
    var color: Color       = AppColors.textPrimary
    var weight: Font.Weight = .regular
    var renderingMode: SymbolRenderingMode = .monochrome

    var body: some View {
        Image(systemName: symbol)
            .symbolRenderingMode(renderingMode)
            .font(.system(size: size, weight: weight))
            .foregroundColor(color)
    }
}

// MARK: - Neon Icon

/// An SF Symbol with a neon glow effect — for accent icons in the UI.
struct NeonIconView: View {
    let symbol: String
    var size: CGFloat = 24
    var color: Color  = AppColors.neonCyan

    var body: some View {
        Image(systemName: symbol)
            .font(.system(size: size, weight: .semibold))
            .foregroundColor(color)
            .neonGlow(AppShadow.neonCyan)
    }
}

#Preview("Icons") {
    ZStack {
        AppColors.background.ignoresSafeArea()
        VStack(spacing: 20) {
            AppIconView(symbol: AppIcon.code,      color: AppColors.neonCyan)
            AppIconView(symbol: AppIcon.trophy,    color: AppColors.warning)
            AppIconView(symbol: AppIcon.ai,        color: AppColors.neonPurple)
            NeonIconView(symbol: AppIcon.xp)
            NeonIconView(symbol: AppIcon.streak, color: AppColors.warning)
        }
    }
}
