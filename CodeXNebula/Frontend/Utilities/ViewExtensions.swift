//
//  ViewExtensions.swift
//  CodeXNebula
//
//  General SwiftUI View extensions used across the app.
//  Keeps modifier chains clean and readable.
//

import SwiftUI
import UIKit

// MARK: - Screen Background

extension View {
    /// Fills the entire safe-area background with the app's primary background colour.
    func appBackground() -> some View {
        self.background(AppColors.background.ignoresSafeArea())
    }

    /// Fills with a vertical gradient from background to secondaryBackground.
    func nebulaBackground() -> some View {
        self.background(
            LinearGradient(
                colors: [AppColors.background, AppColors.backgroundSecondary],
                startPoint: .top, endPoint: .bottom
            )
            .ignoresSafeArea()
        )
    }
}

// MARK: - Section Header

struct SectionHeader: View {
    let title: String
    var subtitle: String?  = nil
    var action: String?    = nil
    var onAction: (() -> Void)? = nil

    var body: some View {
        HStack(alignment: .bottom) {
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(AppFonts.title3)
                    .foregroundColor(AppColors.textPrimary)
                if let subtitle {
                    Text(subtitle)
                        .font(AppFonts.caption)
                        .foregroundColor(AppColors.textSecondary)
                }
            }
            Spacer()
            if let action, let onAction {
                Button(action: onAction) {
                    Text(action)
                        .font(AppFonts.callout)
                        .foregroundColor(AppColors.neonCyan)
                }
                .buttonStyle(.plain)
            }
        }
    }
}

// MARK: - Neon Divider

struct NeonDivider: View {
    var color: Color = AppColors.neonCyan

    var body: some View {
        Rectangle()
            .fill(
                LinearGradient(
                    colors: [.clear, color.opacity(0.5), .clear],
                    startPoint: .leading, endPoint: .trailing
                )
            )
            .frame(height: 1)
    }
}

// MARK: - Chip / Tag

struct TagChip: View {
    let text: String
    var color: Color = AppColors.neonCyan

    var body: some View {
        Text(text)
            .font(AppFonts.codeSmall)
            .foregroundColor(color)
            .padding(.horizontal, AppSpacing.xs)
            .padding(.vertical, AppSpacing.xxs)
            .background(Capsule().fill(color.opacity(0.12)))
            .overlay(Capsule().strokeBorder(color.opacity(0.3), lineWidth: 1))
    }
}

// MARK: - Empty State

// Empty state and Loading components have been moved to their own files.

// MARK: - Conditional Redacted Placeholder

extension View {
    func skeleton(when loading: Bool) -> some View {
        self
            .redacted(reason: loading ? .placeholder : [])
            .shimmering(active: loading)
    }
}

// MARK: - Shimmer Effect

struct ShimmerModifier: ViewModifier {
    let active: Bool
    @State private var phase: CGFloat = 0

    func body(content: Content) -> some View {
        if active {
            content.overlay(
                LinearGradient(
                    colors: [.clear, .white.opacity(0.12), .clear],
                    startPoint: .init(x: phase - 0.4, y: 0),
                    endPoint:   .init(x: phase + 0.4, y: 0)
                )
                .blendMode(.screen)
            )
            .onAppear {
                withAnimation(.linear(duration: 1.4).repeatForever(autoreverses: false)) {
                    phase = 1.5
                }
            }
        } else {
            content
        }
    }
}

extension View {
    func shimmering(active: Bool = true) -> some View {
        modifier(ShimmerModifier(active: active))
    }
}

// MARK: - Rounded Corner Shape

/// A Shape that rounds only specific corners — used by cornerRadius(_:corners:).
struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

extension View {
    /// Clips the view to a rounded rectangle with per-corner control.
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

// HapticManager now handles haptics.
