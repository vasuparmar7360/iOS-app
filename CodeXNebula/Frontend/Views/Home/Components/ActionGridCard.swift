//
//  ActionGridCard.swift
//  CodeXNebula
//
//  Quick action tile for the dashboard.
//

import SwiftUI

struct ActionGridCard: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            GlassCard(
                borderColor: color.opacity(0.3),
                padding: AppSpacing.md,
                glowColor: color
            ) {
                VStack(alignment: .leading, spacing: AppSpacing.sm) {
                    ZStack {
                        Circle()
                            .fill(color.opacity(0.15))
                            .frame(width: 44, height: 44)
                        
                        Image(systemName: icon)
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(color)
                    }
                    
                    Text(title)
                        .font(AppFonts.callout)
                        .foregroundColor(AppColors.textPrimary)
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .frame(height: 90)
            }
        }
        .buttonStyle(.plain)
        .pressAnimation()
    }
}

#Preview {
    ZStack {
        AppColors.background.ignoresSafeArea()
        HStack(spacing: AppSpacing.md) {
            ActionGridCard(title: "Start\nCoding", icon: "chevron.left.forwardslash.chevron.right", color: AppColors.neonCyan) {}
            ActionGridCard(title: "AI\nMentor", icon: "cpu", color: AppColors.neonPurple) {}
        }
        .padding()
    }
}
