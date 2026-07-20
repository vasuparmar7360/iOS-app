//
//  OutlineButton.swift
//  CodeXNebula
//
//  Transparent background with a gradient or solid neon border.
//  Used for tertiary actions and selections.
//

import SwiftUI

// MARK: - OutlineButton

struct OutlineButton: View {

    let title: String
    var icon: String?       = nil
    var isSelected: Bool    = false
    var isDisabled: Bool    = false
    var accentColor: Color  = AppColors.neonPurple
    var fullWidth: Bool     = false
    let action: () -> Void

    @State private var isPressed = false

    // -------------------------------------------------------------------------
    var body: some View {
        Button(action: {
            guard !isDisabled else { return }
            action()
        }) {
            HStack(spacing: AppSpacing.xs) {
                if let icon {
                    Image(systemName: icon)
                        .font(.system(size: 14, weight: .medium))
                }
                Text(title)
                    .font(AppFonts.buttonSecondary)
            }
            .foregroundColor(
                isDisabled  ? AppColors.textTertiary :
                isSelected  ? accentColor :
                AppColors.textSecondary
            )
            .frame(maxWidth: fullWidth ? .infinity : nil)
            .padding(.vertical, AppSpacing.xs + 2)
            .padding(.horizontal, AppSpacing.md)
            .background(
                RoundedRectangle(cornerRadius: AppRadius.button)
                    .fill(isSelected ? accentColor.opacity(0.12) : Color.clear)
            )
            .overlay(
                RoundedRectangle(cornerRadius: AppRadius.button)
                    .strokeBorder(
                        isDisabled  ? AppColors.borderSubtle :
                        isSelected  ? accentColor :
                        AppColors.divider,
                        lineWidth: isSelected ? 1.5 : 1
                    )
            )
            .scaleEffect(isPressed ? 0.96 : 1.0)
            .opacity(isDisabled ? 0.4 : (isPressed ? 0.85 : 1.0))
            .animation(AppAnimation.snappy, value: isPressed)
            .animation(AppAnimation.standard, value: isSelected)
        }
        .buttonStyle(.plain)
        .disabled(isDisabled)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isPressed = true }
                .onEnded   { _ in isPressed = false }
        )
    }
}

// MARK: - Preview

#Preview("OutlineButton") {
    ZStack {
        AppColors.background.ignoresSafeArea()
        VStack(spacing: 16) {
            HStack {
                OutlineButton(title: "Easy",   isSelected: false) {}
                OutlineButton(title: "Medium", isSelected: true)  {}
                OutlineButton(title: "Hard",   isSelected: false) {}
            }
            OutlineButton(title: "Disabled", isDisabled: true) {}
            OutlineButton(title: "Full Width", fullWidth: true) {}
        }
        .padding()
    }
}
