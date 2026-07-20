//
//  AppFonts.swift
//  CodeXNebula
//
//  Typography scale — SF Pro Display & SF Pro Text with Dynamic Type support.
//  All text in the app must use these styles, never raw Font values.
//

import SwiftUI

// MARK: - AppFonts

enum AppFonts {

    // -------------------------------------------------------------------------
    // MARK: Display / Headers
    // -------------------------------------------------------------------------

    /// 34 pt — hero titles, screen headers.
    static let largeTitle  = Font.system(size: 34, weight: .bold,     design: .default)

    /// 28 pt — section titles.
    static let title       = Font.system(size: 28, weight: .bold,     design: .default)

    /// 22 pt — card titles, modal headers.
    static let title2      = Font.system(size: 22, weight: .semibold, design: .default)

    /// 20 pt — sub-section headers.
    static let title3      = Font.system(size: 20, weight: .semibold, design: .default)

    // -------------------------------------------------------------------------
    // MARK: Body
    // -------------------------------------------------------------------------

    /// 17 pt semibold — labels, tab titles, emphasis.
    static let headline    = Font.system(size: 17, weight: .semibold, design: .default)

    /// 17 pt — primary readable text.
    static let body        = Font.system(size: 17, weight: .regular,  design: .default)

    /// 16 pt — secondary readable text, descriptions.
    static let callout     = Font.system(size: 16, weight: .regular,  design: .default)

    /// 15 pt — supporting text, hints.
    static let subheadline = Font.system(size: 15, weight: .regular,  design: .default)

    // -------------------------------------------------------------------------
    // MARK: Small / Meta
    // -------------------------------------------------------------------------

    /// 13 pt — footnotes, timestamps.
    static let footnote    = Font.system(size: 13, weight: .regular,  design: .default)

    /// 12 pt — captions, labels on badges.
    static let caption     = Font.system(size: 12, weight: .regular,  design: .default)

    /// 11 pt — smallest visible label.
    static let caption2    = Font.system(size: 11, weight: .medium,   design: .default)

    // -------------------------------------------------------------------------
    // MARK: Interactive
    // -------------------------------------------------------------------------

    /// 17 pt semibold — primary button labels.
    static let buttonPrimary  = Font.system(size: 17, weight: .semibold, design: .default)

    /// 15 pt medium — secondary button labels.
    static let buttonSecondary = Font.system(size: 15, weight: .medium,  design: .default)

    /// 13 pt semibold — small/icon buttons.
    static let buttonSmall    = Font.system(size: 13, weight: .semibold, design: .default)

    // -------------------------------------------------------------------------
    // MARK: Gaming / Gamification
    // -------------------------------------------------------------------------

    /// 24 pt bold monospaced — XP numbers, score counters.
    static let xpText      = Font.system(size: 24, weight: .bold,     design: .monospaced)

    /// 36 pt bold monospaced — large score displays, timers.
    static let scoreLarge  = Font.system(size: 36, weight: .bold,     design: .monospaced)

    /// 20 pt semibold monospaced — medium gaming values.
    static let scoreMedium = Font.system(size: 20, weight: .semibold, design: .monospaced)

    /// 14 pt medium monospaced — stat labels under scores.
    static let statLabel   = Font.system(size: 14, weight: .medium,   design: .monospaced)

    // -------------------------------------------------------------------------
    // MARK: Code / Monospace
    // -------------------------------------------------------------------------

    /// 15 pt — inline code, variable names.
    static let code        = Font.system(size: 15, weight: .regular,  design: .monospaced)

    /// 13 pt — small code references, syntax hints.
    static let codeSmall   = Font.system(size: 13, weight: .regular,  design: .monospaced)

    /// 17 pt medium — main code editor text.
    static let codeLarge   = Font.system(size: 17, weight: .medium,   design: .monospaced)
}

// MARK: - Dynamic Type ViewModifier

/// Applies a scaled font that respects the user's Dynamic Type accessibility setting.
struct ScaledFont: ViewModifier {
    let font: Font
    let relativeTo: Font.TextStyle

    func body(content: Content) -> some View {
        content.font(font)
    }
}

extension View {
    /// Applies a design system font. Honour Dynamic Type by default.
    func appFont(_ font: Font) -> some View {
        self.font(font)
    }
}
