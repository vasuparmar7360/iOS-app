//
//  AppSpacing.swift
//  CodeXNebula
//
//  Spacing and corner-radius constants.
//  All layout values in the app must reference these — never use raw CGFloat.
//

import SwiftUI

// MARK: - AppSpacing

enum AppSpacing {

    // -------------------------------------------------------------------------
    // MARK: Base Scale (8-pt grid)
    // -------------------------------------------------------------------------

    ///  2 pt
    static let xxxs: CGFloat = 2
    ///  4 pt
    static let xxs: CGFloat  = 4
    ///  8 pt
    static let xs: CGFloat   = 8
    /// 12 pt
    static let sm: CGFloat   = 12
    /// 16 pt
    static let md: CGFloat   = 16
    /// 20 pt
    static let lg: CGFloat   = 20
    /// 24 pt
    static let xl: CGFloat   = 24
    /// 32 pt
    static let xxl: CGFloat  = 32
    /// 48 pt
    static let xxxl: CGFloat = 48
    /// 64 pt
    static let huge: CGFloat = 64

    // -------------------------------------------------------------------------
    // MARK: Semantic Aliases
    // -------------------------------------------------------------------------

    /// Inner padding for small badges / chips.
    static let paddingSmall: CGFloat  = xs       // 8

    /// Standard inner padding for cards and sections.
    static let paddingMedium: CGFloat = md       // 16

    /// Generous padding for hero cards.
    static let paddingLarge: CGFloat  = xl       // 24

    /// Screen edge insets.
    static let screenPadding: CGFloat = md       // 16

    /// Vertical gap between list rows.
    static let rowSpacing: CGFloat    = sm       // 12

    /// Gap between stacked cards.
    static let cardSpacing: CGFloat   = md       // 16
}

// MARK: - AppRadius

enum AppRadius {

    /// 4 pt — badges, small chips.
    static let sm: CGFloat     = 4
    /// 8 pt — tags, small buttons.
    static let md: CGFloat     = 8
    /// 12 pt — standard buttons.
    static let button: CGFloat = 12
    /// 16 pt — cards.
    static let card: CGFloat   = 16
    /// 20 pt — large cards, sheets.
    static let lg: CGFloat     = 20
    /// 28 pt — hero elements.
    static let xl: CGFloat     = 28
    /// 999 pt — fully pill-shaped.
    static let pill: CGFloat   = 999
}
