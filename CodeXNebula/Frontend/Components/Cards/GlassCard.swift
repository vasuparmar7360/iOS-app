//
//  GlassCard.swift
//  CodeXNebula
//
//  The base glassmorphism card — the foundation for all other card variants.
//  Can be used standalone or as a container for custom content.
//

import SwiftUI

// MARK: - GlassCard

struct GlassCard<Content: View>: View {

    var cornerRadius: CGFloat   = AppRadius.card
    var borderColor: Color      = AppColors.borderSubtle
    var borderWidth: CGFloat    = 1
    var padding: CGFloat        = AppSpacing.paddingMedium
    var glowColor: Color?       = nil
    @ViewBuilder var content: () -> Content

    // -------------------------------------------------------------------------
    var body: some View {
        content()
            .padding(padding)
            .background(
                ZStack {
                    // Blur material base
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(.ultraThinMaterial)

                    // Glass tint overlay
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(AppColors.glassBackground)
                }
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .strokeBorder(borderColor, lineWidth: borderWidth)
            )
            .shadow(
                color: Color.black.opacity(0.4),
                radius: 16,
                x: 0, y: 8
            )
            .modifier(
                OptionalNeonGlowModifier(color: glowColor)
            )
    }
}

// MARK: - Helper modifier for optional glow

private struct OptionalNeonGlowModifier: ViewModifier {
    let color: Color?

    func body(content: Content) -> some View {
        if let color {
            content
                .shadow(color: color.opacity(0.35), radius: 16, x: 0, y: 0)
                .shadow(color: color.opacity(0.20), radius: 30, x: 0, y: 0)
        } else {
            content
        }
    }
}

// MARK: - Preview

#Preview("GlassCard") {
    ZStack {
        LinearGradient(
            colors: [AppColors.background, AppColors.backgroundSecondary],
            startPoint: .top, endPoint: .bottom
        )
        .ignoresSafeArea()

        VStack(spacing: 20) {
            // Basic glass card
            GlassCard {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Glass Card")
                        .font(AppFonts.title3)
                        .foregroundColor(AppColors.textPrimary)
                    Text("Glassmorphism foundation component.")
                        .font(AppFonts.body)
                        .foregroundColor(AppColors.textSecondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }

            // Cyan glow glass card
            GlassCard(
                borderColor: AppColors.neonCyan.opacity(0.4),
                glowColor: AppColors.neonCyan
            ) {
                Text("Neon Cyan Glow Card")
                    .font(AppFonts.headline)
                    .foregroundColor(AppColors.neonCyan)
            }
        }
        .padding()
    }
}
