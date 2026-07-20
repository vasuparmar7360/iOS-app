//
//  BattleHomeView.swift
//  CodeXNebula
//

import SwiftUI

struct BattleHomeView: View {
    @StateObject private var viewModel = BattleViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppColors.background.ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: AppSpacing.lg) {
                        // Stats Section
                        VStack(alignment: .leading, spacing: AppSpacing.sm) {
                            Text("Battle Profile")
                                .appFont(AppFonts.title2)
                                .foregroundColor(AppColors.textPrimary)
                            
                            GlassCard(padding: AppSpacing.md) {
                                VStack(spacing: AppSpacing.md) {
                                    HStack {
                                        VStack(alignment: .leading) {
                                            Text(viewModel.currentRank)
                                                .appFont(AppFonts.title3)
                                                .foregroundColor(AppColors.neonCyan)
                                            Text("Current Rank")
                                                .font(AppFonts.caption)
                                                .foregroundColor(AppColors.textSecondary)
                                        }
                                        Spacer()
                                        VStack(alignment: .trailing) {
                                            Text("\(viewModel.battleXP) XP")
                                                .appFont(AppFonts.title3)
                                                .foregroundColor(AppColors.neonPurple)
                                            Text("Battle XP")
                                                .font(AppFonts.caption)
                                                .foregroundColor(AppColors.textSecondary)
                                        }
                                    }
                                    
                                    Divider().background(AppColors.borderSubtle)
                                    
                                    HStack(spacing: AppSpacing.md) {
                                        StatBox(title: "Wins", value: "\(viewModel.totalWins)", color: AppColors.success)
                                        StatBox(title: "Battles", value: "\(viewModel.totalBattles)", color: AppColors.neonCyan)
                                        StatBox(title: "Win Rate", value: "\(Int(viewModel.winRate * 100))%", color: AppColors.warning)
                                    }
                                }
                                .frame(maxWidth: .infinity)
                            }
                        }
                        
                        // Actions
                        NavigationLink(destination: FriendListView(viewModel: viewModel)) {
                            HStack(spacing: AppSpacing.xs) {
                                Image(systemName: "person.2.fill")
                                    .font(.system(size: 16, weight: .semibold))
                                Text("Challenge Friends")
                                    .font(AppFonts.buttonPrimary)
                            }
                            .foregroundColor(AppColors.background)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, AppSpacing.sm + 2)
                            .padding(.horizontal, AppSpacing.xl)
                            .background(
                                RoundedRectangle(cornerRadius: AppRadius.button)
                                    .fill(AppColors.gradientCyan)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: AppRadius.button)
                                    .strokeBorder(AppColors.neonCyan.opacity(0.4), lineWidth: 1)
                            )
                            .shadow(color: AppColors.neonCyan.opacity(0.45), radius: 14, x: 0, y: 6)
                        }
                        .buttonStyle(.plain)
                        
                        // Recent Battles
                        VStack(alignment: .leading, spacing: AppSpacing.sm) {
                            Text("Recent Battles")
                                .appFont(AppFonts.headline)
                                .foregroundColor(AppColors.textPrimary)
                            
                            if viewModel.battleHistory.isEmpty {
                                Text("No recent battles.")
                                    .font(AppFonts.body)
                                    .foregroundColor(AppColors.textSecondary)
                                    .padding(.vertical)
                            } else {
                                ForEach(viewModel.battleHistory) { battle in
                                    BattleHistoryCard(battle: battle)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Spacer(minLength: 40)
                    }
                    .padding(AppSpacing.md)
                }
            }
            .navigationTitle("Battle Arena")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(AppColors.background, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .task {
                await viewModel.loadInitialData()
            }
        }
    }
}

struct StatBox: View {
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .appFont(AppFonts.title2)
                .foregroundColor(color)
            Text(title)
                .font(AppFonts.caption)
                .foregroundColor(AppColors.textSecondary)
        }
        .frame(maxWidth: .infinity)
    }
}

struct BattleHistoryCard: View {
    let battle: Battle
    
    var body: some View {
        GlassCard(padding: AppSpacing.md) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Vs. Opponent") 
                        .appFont(AppFonts.headline)
                        .foregroundColor(AppColors.textPrimary)
                    Text("\(battle.languageId.capitalized) • \(battle.durationMinutes)m")
                        .font(AppFonts.caption)
                        .foregroundColor(AppColors.textSecondary)
                }
                Spacer()
                Text(battle.status.rawValue)
                    .font(AppFonts.caption)
                    .foregroundColor(AppColors.success)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(AppColors.success.opacity(0.1))
                    .cornerRadius(4)
            }
            .frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    BattleHomeView()
}
