//
//  EmptyStateView.swift
//  CodeXNebula
//

import SwiftUI

struct EmptyStateView: View {
    let iconName: String
    let title: String
    let message: String
    var actionTitle: String? = nil
    var action: (() -> Void)? = nil
    
    var body: some View {
        VStack(spacing: AppSpacing.lg) {
            Image(systemName: iconName)
                .font(.system(size: 56, weight: .light))
                .foregroundColor(AppColors.neonCyan)
                .opacity(0.85)
                .pulseEffect()
            
            Text(title)
                .font(AppFonts.title2)
                .foregroundColor(AppColors.textPrimary)
                .multilineTextAlignment(.center)
            
            Text(message)
                .font(AppFonts.body)
                .foregroundColor(AppColors.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, AppSpacing.xl)
            
            if let actionTitle = actionTitle, let action = action {
                PrimaryButton(title: actionTitle, action: action)
                    .padding(.top, AppSpacing.md)
                    .padding(.horizontal, AppSpacing.xl)
            }
        }
        .padding()
        .scaleIn(delay: 0.1)
    }
}
