//
//  HomeView.swift
//  CodeXNebula
//
//  Main dashboard screen containing user progress, missions, and quick actions.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var appState: AppState
    @StateObject private var viewModel = HomeViewModel()
    @StateObject private var achViewModel = AchievementViewModel()
    
    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: AppSpacing.xxl) {
                    
                    // 1. TOP SECTION (Welcome & Avatar)
                    topProfileSection
                    
                    // 2. GAMIFICATION SECTION
                    gamificationSection
                    
                    // 3. DAILY MISSION SECTION
                    dailyMissionSection
                    
                    // 4. LEARNING JOURNEY SECTION
                    learningJourneySection
                    
                    // 5. QUICK ACTION SECTION
                    quickActionSection
                    
                    Spacer(minLength: 40)
                }
                .padding(.vertical, AppSpacing.lg)
            }
            .refreshable {
                await viewModel.refreshData()
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            viewModel.setup(with: appState.currentUser)
        }
        .task {
            await achViewModel.loadData()
        }
    }
    
    // MARK: - Sections
    
    private var topProfileSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            Text("Welcome back,")
                .font(AppFonts.callout)
                .foregroundColor(AppColors.textSecondary)
            
            ProfileCard(
                username: viewModel.currentUser?.username ?? "User",
                handle: viewModel.currentUser?.username.lowercased() ?? "user",
                level: viewModel.currentUser?.level ?? 1,
                rank: "Novice",
                xp: viewModel.currentUser?.xp ?? 100,
                streak: 1,
                isCurrentUser: true
            )
        }
        .padding(.horizontal, AppSpacing.md)
        .slideUp(delay: 0.1)
    }
    
    private var gamificationSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            SectionHeader(title: "Progression")
                .padding(.horizontal, AppSpacing.md)
            
            GlassCard(padding: AppSpacing.md) {
                XPProgressView(currentXP: viewModel.currentUser?.xp ?? 1500)
            }
            .padding(.horizontal, AppSpacing.md)
            
            if let streak = achViewModel.streak {
                DailyStreakView(streak: streak)
                    .padding(.horizontal, AppSpacing.md)
            }
        }
        .slideUp(delay: 0.2)
    }
    
    private var dailyMissionSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            SectionHeader(title: "Daily Missions", action: "View All", onAction: {})
                .padding(.horizontal, AppSpacing.md)
            
            ForEach(viewModel.dailyMissions) { mission in
                MissionCard(
                    title: mission.title,
                    description: mission.description,
                    difficulty: .easy,
                    language: "General",
                    xpReward: mission.xpReward,
                    isCompleted: mission.isCompleted
                )
                .padding(.horizontal, AppSpacing.md)
            }
        }
        .slideUp(delay: 0.3)
    }
    
    private var learningJourneySection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            SectionHeader(title: "Continue Learning")
                .padding(.horizontal, AppSpacing.md)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: AppSpacing.md) {
                    ForEach(viewModel.learningLanguages) { lang in
                        LanguageProgressCard(language: lang)
                    }
                }
                .padding(.horizontal, AppSpacing.md)
                .padding(.vertical, AppSpacing.xs)
            }
        }
        .slideUp(delay: 0.4)
    }
    
    private var quickActionSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            SectionHeader(title: "Quick Actions")
                .padding(.horizontal, AppSpacing.md)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: AppSpacing.md) {
                ActionGridCard(title: "Start Coding", icon: "chevron.left.forwardslash.chevron.right", color: AppColors.neonCyan) {
                    // Navigate to playground
                }
                ActionGridCard(title: "View Challenges", icon: "list.bullet.rectangle.portrait", color: AppColors.warning) {
                    // Navigate to challenges
                }
                ActionGridCard(title: "AI Mentor", icon: "cpu", color: AppColors.neonPurple) {
                    // Navigate to AI mentor
                }
                ActionGridCard(title: "Leaderboard", icon: "trophy", color: AppColors.success) {
                    // Navigate to leaderboard
                }
            }
            .padding(.horizontal, AppSpacing.md)
        }
        .slideUp(delay: 0.5)
    }
}

#Preview {
    HomeView()
        .environmentObject(AppState())
}
