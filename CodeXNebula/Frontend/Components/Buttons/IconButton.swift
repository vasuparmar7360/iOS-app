//
//  IconButton.swift
//  CodeXNebula
//
//  A compact circular icon button for toolbars, navigation bars,
//  and inline actions.
//

import SwiftUI

// MARK: - IconButton

struct IconButton: View {

    let icon: String
    var size: CGFloat       = 44
    var iconSize: CGFloat   = 20
    var tintColor: Color    = AppColors.textSecondary
    var style: Style        = .ghost
    var isDisabled: Bool    = false
    var badge: Int?         = nil
    var accessibilityLabel: String? = nil
    let action: () -> Void

    @State private var isPressed = false

    // -------------------------------------------------------------------------
    enum Style {
        case ghost      // No background
        case filled     // Solid card background
        case neon       // Glowing border
    }

    // -------------------------------------------------------------------------
    var body: some View {
        Button(action: {
            guard !isDisabled else { return }
            action()
        }) {
            ZStack(alignment: .topTrailing) {
                Image(systemName: icon)
                    .font(.system(size: iconSize, weight: .medium))
                    .foregroundColor(isDisabled ? AppColors.textTertiary : tintColor)
                    .frame(width: size, height: size)
                    .background(backgroundView)
                    .clipShape(Circle())
                    .overlay(borderOverlay)
                    .scaleEffect(isPressed ? 0.90 : 1.0)
                    .opacity(isDisabled ? 0.4 : 1.0)
                    .animation(AppAnimation.snappy, value: isPressed)

                // Badge
                if let badge, badge > 0 {
                    ZStack {
                        Circle()
                            .fill(AppColors.error)
                            .frame(width: 18, height: 18)
                        Text(badge > 99 ? "99+" : "\(badge)")
                            .font(AppFonts.caption2)
                            .foregroundColor(.white)
                    }
                    .offset(x: 4, y: -4)
                }
            }
        }
        .buttonStyle(.plain)
        .disabled(isDisabled)
        .accessibilityLabel(Text(accessibilityLabel ?? icon.capitalized))
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isPressed = true }
                .onEnded   { _ in isPressed = false }
        )
    }

    // -------------------------------------------------------------------------
    @ViewBuilder
    private var backgroundView: some View {
        switch style {
        case .ghost:
            Color.clear
        case .filled:
            AppColors.cardBackground
        case .neon:
            tintColor.opacity(0.10)
        }
    }

    @ViewBuilder
    private var borderOverlay: some View {
        switch style {
        case .neon:
            Circle().strokeBorder(tintColor.opacity(0.45), lineWidth: 1.5)
        default:
            EmptyView()
        }
    }
}

// MARK: - Preview

#Preview("IconButton") {
    ZStack {
        AppColors.background.ignoresSafeArea()
        HStack(spacing: 20) {
            IconButton(icon: AppIcon.close,    style: .ghost)  {}
            IconButton(icon: AppIcon.settings, style: .filled) {}
            IconButton(icon: AppIcon.xp,
                       tintColor: AppColors.neonCyan,
                       style: .neon,
                       badge: 5) {}
            IconButton(icon: AppIcon.lock,     isDisabled: true) {}
        }
    }
}
