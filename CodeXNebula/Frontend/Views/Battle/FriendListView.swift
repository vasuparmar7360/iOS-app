//
//  FriendListView.swift
//  CodeXNebula
//

import SwiftUI

struct FriendListView: View {
    @ObservedObject var viewModel: BattleViewModel
    
    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()
            
            if viewModel.isLoadingFriends {
                ProgressView()
                    .tint(AppColors.neonCyan)
            } else {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: AppSpacing.md) {
                        ForEach(viewModel.friends) { friend in
                            NavigationLink(destination: InviteFriendView(viewModel: viewModel, friend: friend)) {
                                FriendRow(friend: friend)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(AppSpacing.md)
                }
            }
        }
        .navigationTitle("Friends")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct FriendRow: View {
    let friend: Friend
    
    var body: some View {
        GlassCard(padding: AppSpacing.md) {
            HStack(spacing: AppSpacing.md) {
                // Avatar placeholder
                Circle()
                    .fill(AppColors.cardBackground)
                    .frame(width: 48, height: 48)
                    .overlay(
                        Text(String(friend.username.prefix(1)))
                            .appFont(AppFonts.title3)
                            .foregroundColor(AppColors.neonCyan)
                    )
                    .overlay(
                        Circle().stroke(friend.isOnline ? AppColors.success : AppColors.textTertiary, lineWidth: 2)
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(friend.username)
                        .appFont(AppFonts.headline)
                        .foregroundColor(AppColors.textPrimary)
                    Text("Level \(friend.level)")
                        .font(AppFonts.caption)
                        .foregroundColor(AppColors.textSecondary)
                }
                
                Spacer()
                
                Text(friend.isOnline ? "Online" : "Offline")
                    .font(AppFonts.caption)
                    .foregroundColor(friend.isOnline ? AppColors.success : AppColors.textTertiary)
                
                Image(systemName: "bolt.shield.fill")
                    .font(.system(size: 20))
                    .foregroundColor(friend.isOnline ? AppColors.neonCyan : AppColors.textTertiary)
                    .padding(.leading, 8)
            }
            .frame(maxWidth: .infinity)
        }
        .opacity(friend.isOnline ? 1.0 : 0.6)
    }
}
