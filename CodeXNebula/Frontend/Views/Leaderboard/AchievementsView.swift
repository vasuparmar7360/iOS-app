//
//  AchievementsView.swift
//  CodeXNebula
//

import SwiftUI

struct AchievementsView: View {
    @StateObject private var viewModel = AchievementViewModel()
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()
            
            if viewModel.isLoading {
                ProgressView().scaleEffect(1.5).progressViewStyle(CircularProgressViewStyle(tint: AppColors.neonPurple))
            } else {
                ScrollView {
                    VStack(spacing: AppSpacing.xl) {
                        if let streak = viewModel.streak {
                            DailyStreakView(streak: streak)
                                .padding(.horizontal)
                        }
                        
                        VStack(alignment: .leading, spacing: AppSpacing.md) {
                            Text("Badges & Achievements")
                                .appFont(AppFonts.title2)
                                .foregroundColor(AppColors.textPrimary)
                                .padding(.horizontal)
                            
                            LazyVGrid(columns: columns, spacing: AppSpacing.lg) {
                                ForEach(viewModel.achievements) { achievement in
                                    NavigationLink(destination: AchievementDetailView(achievement: achievement)) {
                                        AchievementGridItem(achievement: achievement)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.vertical)
                }
            }
        }
        .navigationTitle("Achievements")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.loadData()
        }
    }
}

struct AchievementGridItem: View {
    let achievement: Achievement
    
    var body: some View {
        VStack(spacing: AppSpacing.sm) {
            ZStack {
                Circle()
                    .fill(AppColors.cardBackground)
                    .frame(width: 80, height: 80)
                    .overlay(
                        Circle().stroke(achievement.isUnlocked ? achievement.badge.color : AppColors.borderSubtle, lineWidth: 2)
                    )
                
                Image(systemName: achievement.isUnlocked ? "star.fill" : "lock.fill")
                    .font(.system(size: 30))
                    .foregroundColor(achievement.isUnlocked ? achievement.badge.color : AppColors.textTertiary)
                    .shadow(color: achievement.isUnlocked ? achievement.badge.color.opacity(0.5) : .clear, radius: 10)
            }
            
            Text(achievement.title)
                .font(AppFonts.caption)
                .foregroundColor(achievement.isUnlocked ? AppColors.textPrimary : AppColors.textTertiary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
    }
}
