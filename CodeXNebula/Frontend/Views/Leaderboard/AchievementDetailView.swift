//
//  AchievementDetailView.swift
//  CodeXNebula
//

import SwiftUI

struct AchievementDetailView: View {
    let achievement: Achievement
    
    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()
            
            VStack(spacing: AppSpacing.xl) {
                Spacer()
                
                ZStack {
                    Circle()
                        .fill(AppColors.cardBackground)
                        .frame(width: 150, height: 150)
                        .overlay(
                            Circle().stroke(achievement.isUnlocked ? achievement.badge.color : AppColors.borderSubtle, lineWidth: 4)
                        )
                        .shadow(color: achievement.isUnlocked ? achievement.badge.color.opacity(0.6) : .clear, radius: 20)
                    
                    Image(systemName: achievement.isUnlocked ? "star.fill" : "lock.fill")
                        .font(.system(size: 60))
                        .foregroundColor(achievement.isUnlocked ? achievement.badge.color : AppColors.textTertiary)
                }
                
                VStack(spacing: AppSpacing.sm) {
                    Text(achievement.title)
                        .appFont(AppFonts.title)
                        .foregroundColor(AppColors.textPrimary)
                    
                    Text(achievement.category.uppercased())
                        .font(AppFonts.caption)
                        .foregroundColor(AppColors.neonPurple)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                        .background(AppColors.neonPurple.opacity(0.2))
                        .cornerRadius(12)
                    
                    Text(achievement.description)
                        .font(AppFonts.body)
                        .foregroundColor(AppColors.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, AppSpacing.xl)
                        .padding(.top, AppSpacing.md)
                }
                
                if let date = achievement.unlockedAt {
                    Text("Unlocked on \(date.formatted(date: .abbreviated, time: .shortened))")
                        .font(AppFonts.caption)
                        .foregroundColor(AppColors.textTertiary)
                        .padding(.top, AppSpacing.lg)
                }
                
                Spacer()
            }
        }
    }
}
