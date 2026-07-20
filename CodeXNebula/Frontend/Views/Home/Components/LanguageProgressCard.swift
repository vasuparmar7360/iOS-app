//
//  LanguageProgressCard.swift
//  CodeXNebula
//
//  Card displaying user progress for a specific programming language.
//

import SwiftUI

struct LanguageProgressCard: View {
    let language: LearningLanguage
    
    var body: some View {
        GlassCard(padding: AppSpacing.md) {
            VStack(alignment: .leading, spacing: AppSpacing.md) {
                
                // Icon and Title
                HStack(spacing: AppSpacing.sm) {
                    ZStack {
                        RoundedRectangle(cornerRadius: AppRadius.md)
                            .fill(AppColors.cardBackground)
                            .frame(width: 40, height: 40)
                            .overlay(
                                RoundedRectangle(cornerRadius: AppRadius.md)
                                    .strokeBorder(AppColors.borderSubtle, lineWidth: 1)
                            )
                        
                        Image(systemName: language.iconName)
                            .font(.system(size: 20))
                            .foregroundColor(AppColors.neonCyan)
                    }
                    
                    Text(language.name)
                        .font(AppFonts.headline)
                        .foregroundColor(AppColors.textPrimary)
                    
                    Spacer()
                }
                
                // Progress Bar
                VStack(spacing: AppSpacing.xxs) {
                    HStack {
                        Text("Progress")
                            .font(AppFonts.caption2)
                            .foregroundColor(AppColors.textSecondary)
                        Spacer()
                        Text("\(Int(language.progress * 100))%")
                            .font(AppFonts.caption2)
                            .foregroundColor(AppColors.neonCyan)
                    }
                    XPProgressBar(
                        progress: language.progress,
                        color: AppColors.gradientCyan,
                        showGlow: false
                    )
                    .frame(height: 6)
                }
                
                // Continue Button
                SecondaryButton(title: language.progress > 0 ? "Continue" : "Start", fullWidth: true) {
                    // Action placeholder
                }
            }
        }
        .frame(width: 160)
    }
}

#Preview {
    ZStack {
        AppColors.background.ignoresSafeArea()
        LanguageProgressCard(language: LearningLanguage(id: "1", name: "Swift", progress: 0.45, iconName: "swift"))
            .padding()
    }
}
