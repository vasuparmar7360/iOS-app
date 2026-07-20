//
//  MainTabView.swift
//  CodeXNebula
//
//  Bottom navigation bar containing the main sections of the app.
//

import SwiftUI

struct MainTabView: View {
    @EnvironmentObject private var appState: AppState
    @State private var selectedTab: Tab = .home
    
    enum Tab {
        case home
        case learn
        case battle
        case leaderboard
        case profile
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            
            // Home Dashboard
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(Tab.home)
            
            // Learn
            NavigationStack {
                LanguageSelectionView()
            }
            .tabItem {
                Label("Learn", systemImage: "book.fill")
            }
            .tag(Tab.learn)
            
            // Battle
            BattleHomeView()
                .tabItem {
                    Label("Battle", systemImage: "bolt.shield.fill")
                }
                .tag(Tab.battle)
            
            // Leaderboard
            LeaderboardView()
                .tabItem {
                    Label("Rankings", systemImage: "trophy.fill")
                }
                .tag(Tab.leaderboard)
            
            // Profile
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle.fill")
                }
                .tag(Tab.profile)
        }
        .tint(AppColors.neonCyan)
        .onAppear {
            setupTabBarAppearance()
        }
        .navigationBarBackButtonHidden(true)
    }
    
    private func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(AppColors.cardBackground)
        
        // Unselected states
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor(AppColors.textTertiary)
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor(AppColors.textTertiary)]
        
        // Selected states
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor(AppColors.neonCyan)
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor(AppColors.neonCyan)]
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}

// MARK: - Placeholder View

struct PlaceholderView: View {
    let title: String
    let icon: String
    
    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()
            VStack(spacing: AppSpacing.lg) {
                Image(systemName: icon)
                    .font(.system(size: 64))
                    .foregroundColor(AppColors.textTertiary)
                    .pulseEffect()
                
                Text(title)
                    .appFont(AppFonts.title2)
                    .foregroundColor(AppColors.textPrimary)
                
                Text("Coming soon...")
                    .appFont(AppFonts.body)
                    .foregroundColor(AppColors.textSecondary)
            }
        }
    }
}

#Preview {
    MainTabView()
        .environmentObject(AppState())
}
