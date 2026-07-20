//
//  SecondaryButton.swift
//  CodeXNebula
//
//  A lower-emphasis button with a dark surface background and
//  neon border, used for secondary actions alongside PrimaryButton.
//

import SwiftUI

// MARK: - SecondaryButton

struct SecondaryButton: View {

    let title: String
    var icon: String?       = nil
    var isLoading: Bool     = false
    var isDisabled: Bool    = false
    var fullWidth: Bool     = true
    let action: () -> Void

    @State private var isPressed = false

    // -------------------------------------------------------------------------
    var body: some View {
        Button(action: {
            guard !isDisabled && !isLoading else { return }
            action()
        }) {
            HStack(spacing: AppSpacing.xs) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .tint(AppColors.neonCyan)
                        .scaleEffect(0.85)
                } else {
                    if let icon {
                        Image(systemName: icon)
                            .font(.system(size: 16, weight: .medium))
                    }
                    Text(title)
                        .font(AppFonts.buttonPrimary)
                }
            }
            .foregroundColor(isDisabled ? AppColors.textTertiary : AppColors.neonCyan)
            .frame(maxWidth: fullWidth ? .infinity : nil)
            .padding(.vertical, AppSpacing.sm + 2)
            .padding(.horizontal, AppSpacing.xl)
            .background(
                RoundedRectangle(cornerRadius: AppRadius.button)
                    .fill(AppColors.cardBackground)
            )
            .overlay(
                RoundedRectangle(cornerRadius: AppRadius.button)
                    .strokeBorder(
                        isDisabled
                            ? AppColors.borderSubtle
                            : AppColors.neonCyan.opacity(isPressed ? 0.9 : 0.55),
                        lineWidth: 1.5
                    )
            )
            .scaleEffect(isPressed ? 0.96 : 1.0)
            .opacity(isDisabled ? 0.5 : (isPressed ? 0.88 : 1.0))
            .shadow(
                color: isDisabled ? .clear : AppColors.neonCyan.opacity(0.20),
                radius: 10, x: 0, y: 4
            )
            .animation(AppAnimation.snappy, value: isPressed)
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

#Preview("SecondaryButton") {
    ZStack {
        AppColors.background.ignoresSafeArea()
        VStack(spacing: 20) {
            SecondaryButton(title: "View Profile", icon: AppIcon.profile) {}
            SecondaryButton(title: "Loading...", isLoading: true) {}
            SecondaryButton(title: "Disabled", isDisabled: true) {}
        }
        .padding()
    }
}
