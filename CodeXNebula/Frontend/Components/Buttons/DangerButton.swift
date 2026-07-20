//
//  DangerButton.swift
//  CodeXNebula
//
//  A destructive-action button with red neon styling.
//  Used for delete, forfeit, or irreversible actions.
//

import SwiftUI

// MARK: - DangerButton

struct DangerButton: View {

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
                        .tint(.white)
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
            .foregroundColor(.white)
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
                            .fill(
                                LinearGradient(
                                    colors: [AppColors.error, AppColors.error.opacity(0.75)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    }
                }
            )
            .overlay(
                RoundedRectangle(cornerRadius: AppRadius.button)
                    .strokeBorder(
                        isDisabled ? Color.clear : AppColors.error.opacity(0.5),
                        lineWidth: 1
                    )
            )
            .scaleEffect(isPressed ? 0.96 : 1.0)
            .opacity(isDisabled ? 0.45 : (isPressed ? 0.88 : 1.0))
            .shadow(
                color: isDisabled ? .clear : AppColors.error.opacity(0.40),
                radius: isPressed ? 4 : 12,
                x: 0, y: isPressed ? 2 : 5
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

#Preview("DangerButton") {
    ZStack {
        AppColors.background.ignoresSafeArea()
        VStack(spacing: 20) {
            DangerButton(title: "Forfeit Battle", icon: "xmark.circle.fill") {}
            DangerButton(title: "Processing...", isLoading: true) {}
            DangerButton(title: "Disabled", isDisabled: true) {}
        }
        .padding()
    }
}
