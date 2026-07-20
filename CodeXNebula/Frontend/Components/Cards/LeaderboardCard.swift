//
//  LeaderboardCard.swift
//  CodeXNebula
//
//  A compact leaderboard row card — rank, avatar, username, XP, and delta.
//

import SwiftUI

struct LeaderboardCard: View {
    let rank: Int
    let username: String
    let xp: Int
    let level: Int
    var xpDelta: Int?       = nil   // positive = gained, negative = lost
    var isCurrentUser: Bool = false

    private var rankColor: Color {
        switch rank {
        case 1: return Color(hex: "#FFD700")
        case 2: return Color(hex: "#C0C0C0")
        case 3: return Color(hex: "#CD7F32")
        default: return AppColors.textSecondary
        }
    }

    private var rankIcon: String? {
        switch rank {
        case 1: return "crown.fill"
        case 2: return "medal.fill"
        case 3: return "medal.fill"
        default: return nil
        }
    }

    var body: some View {
        HStack(spacing: AppSpacing.md) {

            // Rank indicator
            ZStack {
                if let icon = rankIcon {
                    Image(systemName: icon)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(rankColor)
                        .shadow(color: rankColor.opacity(0.5), radius: 8)
                } else {
                    Text("#\(rank)")
                        .font(AppFonts.statLabel)
                        .foregroundColor(AppColors.textSecondary)
                }
            }
            .frame(width: 32)

            // Avatar
            ZStack {
                Circle()
                    .fill(isCurrentUser ? AppColors.gradientPrimary : AppColors.gradientCard)
                    .frame(width: 40, height: 40)
                Text(String(username.prefix(2)).uppercased())
                    .font(AppFonts.buttonSmall)
                    .foregroundColor(.white)
            }

            // Username + level
            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 6) {
                    Text(username)
                        .font(AppFonts.headline)
                        .foregroundColor(isCurrentUser ? AppColors.neonCyan : AppColors.textPrimary)
                    if isCurrentUser {
                        Text("YOU")
                            .font(AppFonts.caption2)
                            .foregroundColor(AppColors.neonCyan)
                            .padding(.horizontal, 5).padding(.vertical, 2)
                            .background(Capsule().fill(AppColors.neonCyan.opacity(0.15)))
                    }
                }
                Text("Level \(level)")
                    .font(AppFonts.caption)
                    .foregroundColor(AppColors.textSecondary)
            }

            Spacer()

            // XP + delta
            VStack(alignment: .trailing, spacing: 2) {
                Text("\(xp) XP")
                    .font(AppFonts.scoreMedium)
                    .foregroundColor(isCurrentUser ? AppColors.neonPurple : AppColors.textPrimary)
                if let delta = xpDelta {
                    HStack(spacing: 2) {
                        Image(systemName: delta >= 0 ? "arrow.up" : "arrow.down")
                            .font(.system(size: 9, weight: .bold))
                        Text("\(abs(delta))")
                            .font(AppFonts.caption2)
                    }
                    .foregroundColor(delta >= 0 ? AppColors.success : AppColors.error)
                }
            }
        }
        .padding(AppSpacing.md)
        .background(
            RoundedRectangle(cornerRadius: AppRadius.card)
                .fill(isCurrentUser
                      ? AppColors.neonCyan.opacity(0.06)
                      : AppColors.cardBackground)
        )
        .overlay(
            RoundedRectangle(cornerRadius: AppRadius.card)
                .strokeBorder(
                    isCurrentUser ? AppColors.neonCyan.opacity(0.35) : AppColors.borderSubtle,
                    lineWidth: isCurrentUser ? 1.5 : 1
                )
        )
        .cardShadow()
    }
}

#Preview("LeaderboardCard") {
    ZStack {
        AppColors.background.ignoresSafeArea()
        VStack(spacing: 8) {
            LeaderboardCard(rank: 1, username: "AlphaCodr",  xp: 14200, level: 24, xpDelta: 320)
            LeaderboardCard(rank: 2, username: "NexusCodr",  xp: 12800, level: 22, xpDelta: -50, isCurrentUser: true)
            LeaderboardCard(rank: 3, username: "QuantumBit", xp: 11500, level: 20, xpDelta: 180)
            LeaderboardCard(rank: 4, username: "ByteWitch",  xp: 9800,  level: 18)
        }.padding()
    }
}
