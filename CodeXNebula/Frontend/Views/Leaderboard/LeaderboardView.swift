//
//  LeaderboardView.swift
//  CodeXNebula
//

import SwiftUI

struct LeaderboardView: View {
    @StateObject private var viewModel = LeaderboardViewModel()
    @State private var selectedTab: Int = 0
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.background.ignoresSafeArea()
                
                VStack(spacing: AppSpacing.md) {
                    Picker("Leaderboard Filter", selection: $selectedTab) {
                        Text("Global").tag(0)
                        Text("Friends").tag(1)
                        Text("Weekly").tag(2)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal)
                    
                    if viewModel.isLoading {
                        Spacer()
                        ProgressView().scaleEffect(1.5).progressViewStyle(CircularProgressViewStyle(tint: AppColors.neonCyan))
                        Spacer()
                    } else {
                        ScrollView {
                            VStack(spacing: AppSpacing.sm) {
                                ForEach(viewModel.players) { player in
                                    LeaderboardCard(rank: player.rank, username: player.username, xp: player.xp, level: player.level, isCurrentUser: player.id == "currentUser")
                                }
                            }
                            .padding(.horizontal)
                            .padding(.bottom, AppSpacing.xl)
                        }
                    }
                }
            }
            .navigationTitle("Leaderboard")
            .navigationBarTitleDisplayMode(.inline)
            .task {
                await viewModel.loadLeaderboard()
            }
        }
    }
}
