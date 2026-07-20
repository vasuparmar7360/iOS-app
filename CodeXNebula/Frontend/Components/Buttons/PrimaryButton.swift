//
//  PrimaryButton.swift
//  CodeXNebula
//
//  The main call-to-action button with neon cyan gradient, glow, and
//  press animation. Supports disabled and loading states.
//

import SwiftUI

// MARK: - PrimaryButton

struct PrimaryButton: View {

    let title: String
    var icon: String?           = nil
    var isLoading: Bool         = false
    var isDisabled: Bool        = false
    var fullWidth: Bool         = true
    let action: () -> Void

    @State private var isPressed = false

    // -------------------------------------------------------------------------
    var body: some View {
        Button(action: {
            guard !isDisabled && !isLoading else { return }
            HapticManager.shared.impact(style: .light)
            action()
        }) {
            HStack(spacing: AppSpacing.xs) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .tint(AppColors.background)
                        .scaleEffect(0.85)
                } else {
                    if let icon {
                        Image(systemName: icon)
                            .font(.system(size: 16, weight: .semibold))
                    }
                    Text(title)
                        .font(AppFonts.buttonPrimary)
                }
            }
            .foregroundColor(isDisabled ? AppColors.textTertiary : AppColors.background)
            .frame(maxWidth: fullWidth ? .infinity : nil)
            .padding(.vertical, AppSpacing.sm + 2)
            .padding(.horizontal, AppSpacing.xl)
            .background(
                Group {
                    if isDisabled {
                        RoundedRectangle(cornerRadius: AppRadius.button)
                            .fill(AppColors.borderSubtle)
                    } else {
                        RoundedRectangle(cornerRadius: AppRadius.button)
                            .fill(AppColors.gradientCyan)
                    }
                }
            )
            .overlay(
                RoundedRectangle(cornerRadius: AppRadius.button)
                    .strokeBorder(
                        isDisabled
                            ? Color.clear
                            : AppColors.neonCyan.opacity(0.4),
                        lineWidth: 1
                    )
            )
            .scaleEffect(isPressed ? 0.96 : 1.0)
            .opacity(isDisabled ? 0.5 : (isPressed ? 0.88 : 1.0))
            .shadow(
                color: isDisabled ? .clear : AppColors.neonCyan.opacity(0.45),
                radius: isPressed ? 6 : 14,
                x: 0, y: isPressed ? 2 : 6
            )
            .animation(AppAnimation.snappy, value: isPressed)
            .animation(AppAnimation.standard, value: isDisabled)
        }
        .buttonStyle(.plain)
        .disabled(isDisabled || isLoading)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isPressed = true }
                .onEnded   { _ in isPressed = false }
        )
    }
}

// MARK: - Preview

#Preview("PrimaryButton") {
    ZStack {
        AppColors.background.ignoresSafeArea()
        VStack(spacing: 20) {
            PrimaryButton(title: "Start Mission", icon: AppIcon.mission) {}
            PrimaryButton(title: "Loading...", isLoading: true) {}
            PrimaryButton(title: "Disabled", isDisabled: true) {}
            PrimaryButton(title: "Compact", fullWidth: false) {}
        }
        .padding()
    }
}
