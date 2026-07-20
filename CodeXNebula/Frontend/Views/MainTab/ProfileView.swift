//
//  ProfileView.swift
//  CodeXNebula
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject private var appState: AppState
    @StateObject private var achievementViewModel = AchievementViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppColors.background.ignoresSafeArea()
                
                if achievementViewModel.isLoading {
                    ProgressView().scaleEffect(1.5).progressViewStyle(CircularProgressViewStyle(tint: AppColors.neonPurple))
                } else {
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: AppSpacing.xl) {
                            // User Info Card
                            GlassCard(padding: AppSpacing.lg) {
                                HStack(spacing: AppSpacing.md) {
                                    Circle()
                                        .fill(AppColors.backgroundSecondary)
                                        .frame(width: 80, height: 80)
                                        .overlay(
                                            Text(String((appState.currentUser?.username.prefix(1)) ?? "U"))
                                                .font(AppFonts.title)
                                                .foregroundColor(AppColors.neonCyan)
                                        )
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(appState.currentUser?.username ?? "User")
                                            .font(AppFonts.title2)
                                            .foregroundColor(AppColors.textPrimary)
                                        
                                        Text(appState.currentUser?.email ?? "user@example.com")
                                            .font(AppFonts.caption)
                                            .foregroundColor(AppColors.textSecondary)
                                    }
                                    
                                    Spacer()
                                }
                            }
                            
                            // Level and XP
                            let xp = appState.currentUser?.xp ?? 1500
                            GlassCard(padding: AppSpacing.md) {
                                XPProgressView(currentXP: xp)
                            }
                            
                            // Stats
                            HStack(spacing: AppSpacing.md) {
                                ProfileStatBox(title: "Battles Won", value: "\(appState.currentUser?.battleWins ?? 0)", icon: "bolt.shield.fill", color: AppColors.neonCyan)
                                ProfileStatBox(title: "Problems", value: "\(appState.currentUser?.completedProblems.count ?? 0)", icon: "checkmark.circle.fill", color: AppColors.success)
                                ProfileStatBox(title: "Badges", value: "\(achievementViewModel.achievements.filter({ $0.isUnlocked }).count)", icon: "star.fill", color: AppColors.warning)
                            }
                            
                            // Recent Achievements
                            VStack(alignment: .leading, spacing: AppSpacing.md) {
                                HStack {
                                    Text("Recent Achievements")
                                        .appFont(AppFonts.title3)
                                        .foregroundColor(AppColors.textPrimary)
                                    
                                    Spacer()
                                    
                                    NavigationLink(destination: AchievementsView()) {
                                        Text("View All")
                                            .font(AppFonts.caption)
                                            .foregroundColor(AppColors.neonPurple)
                                    }
                                }
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: AppSpacing.md) {
                                        ForEach(achievementViewModel.achievements.filter({ $0.isUnlocked })) { ach in
                                            NavigationLink(destination: AchievementDetailView(achievement: ach)) {
                                                AchievementGridItem(achievement: ach)
                                                    .frame(width: 100)
                                            }
                                        }
                                    }
                                }
                            }
                            
                            PrimaryButton(title: "Sign Out", icon: "rectangle.portrait.and.arrow.right") {
                                appState.currentUser = nil
                            }
                            .padding(.top, AppSpacing.xl)
                        }
                        .padding(AppSpacing.md)
                    }
                }
            }
            .navigationTitle("Profile")
            .task {
                await achievementViewModel.loadData()
            }
        }
    }
}

struct ProfileStatBox: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        GlassCard(padding: AppSpacing.sm) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(color)
                
                Text(value)
                    .font(AppFonts.title3)
                    .foregroundColor(AppColors.textPrimary)
                
                Text(title)
                    .font(AppFonts.caption)
                    .foregroundColor(AppColors.textSecondary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
        }
    }
}
