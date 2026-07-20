//
//  DailyStreakView.swift
//  CodeXNebula
//

import SwiftUI

struct DailyStreakView: View {
    let streak: DailyStreak
    
    var body: some View {
        GlassCard(padding: AppSpacing.lg) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Daily Streak")
                        .font(AppFonts.headline)
                        .foregroundColor(AppColors.textPrimary)
                    
                    Text("Login every day to earn bonus XP.")
                        .font(AppFonts.caption)
                        .foregroundColor(AppColors.textSecondary)
                }
                
                Spacer()
                
                VStack {
                    Image(systemName: "flame.fill")
                        .font(.system(size: 32))
                        .foregroundColor(AppColors.warning)
                        .shadow(color: AppColors.warning.opacity(0.5), radius: 10)
                    
                    Text("\(streak.currentStreak) Days")
                        .font(AppFonts.headline)
                        .foregroundColor(AppColors.textPrimary)
                }
            }
        }
    }
}
