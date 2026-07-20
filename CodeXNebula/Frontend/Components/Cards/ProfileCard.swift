//
//  ProfileCard.swift
//  CodeXNebula
//
//  User profile summary card — displays avatar, username, level, rank, streak, XP.
//

import SwiftUI

struct ProfileCard: View {
    let username: String
    let handle: String
    let level: Int
    let rank: String
    let xp: Int
    let streak: Int
    var isCurrentUser: Bool = false

    var body: some View {
        GlassCard(
            borderColor: isCurrentUser ? AppColors.neonCyan.opacity(0.45) : AppColors.borderSubtle,
            glowColor: isCurrentUser ? AppColors.neonCyan : nil
        ) {
            VStack(spacing: AppSpacing.lg) {
                HStack(spacing: AppSpacing.md) {
                    // Avatar
                    ZStack {
                        Circle()
                            .fill(AppColors.gradientPrimary)
                            .frame(width: 64, height: 64)
                            .shadow(color: AppColors.neonCyan.opacity(0.4), radius: 12)
                        Text(String(username.prefix(2)).uppercased())
                            .font(AppFonts.title2)
                            .foregroundColor(.white)
                    }

                    VStack(alignment: .leading, spacing: AppSpacing.xxs) {
                        HStack(spacing: 6) {
                            Text(username).font(AppFonts.title3).foregroundColor(AppColors.textPrimary)
                            if isCurrentUser {
                                Text("YOU").font(AppFonts.caption2).foregroundColor(AppColors.neonCyan)
                                    .padding(.horizontal, 6).padding(.vertical, 2)
                                    .background(Capsule().fill(AppColors.neonCyan.opacity(0.15)))
                            }
                        }
                        Text("@\(handle)").font(AppFonts.footnote).foregroundColor(AppColors.textSecondary)
                        HStack(spacing: 4) {
                            Image(systemName: AppIcon.rank).font(.system(size: 10, weight: .semibold)).foregroundColor(AppColors.warning)
                            Text(rank).font(AppFonts.caption).foregroundColor(AppColors.warning)
                        }
                    }
                    Spacer()

                    // Level ring
                    ZStack {
                        Circle().strokeBorder(AppColors.gradientXP, lineWidth: 2.5).frame(width: 48, height: 48)
                        VStack(spacing: 0) {
                            Text("LVL").font(AppFonts.caption2).foregroundColor(AppColors.textSecondary)
                            Text("\(level)").font(AppFonts.scoreMedium).foregroundColor(AppColors.neonPurple)
                        }
                    }
                }

                Divider().background(AppColors.divider)

                // Stats row
                HStack {
                    statItem(value: "\(xp)", label: "Total XP",   color: AppColors.neonPurple, icon: AppIcon.xp)
                    Spacer()
                    Rectangle().fill(AppColors.divider).frame(width: 1, height: 28)
                    Spacer()
                    statItem(value: "\(streak)d", label: "Streak",    color: AppColors.warning,    icon: AppIcon.streak)
                    Spacer()
                    Rectangle().fill(AppColors.divider).frame(width: 1, height: 28)
                    Spacer()
                    statItem(value: "Lv.\(level)", label: "Level",  color: AppColors.neonCyan,   icon: AppIcon.level)
                }
            }
        }
    }

    private func statItem(value: String, label: String, color: Color, icon: String) -> some View {
        VStack(spacing: AppSpacing.xxs) {
            HStack(spacing: 4) {
                Image(systemName: icon).font(.system(size: 10, weight: .semibold)).foregroundColor(color)
                Text(value).font(AppFonts.scoreMedium).foregroundColor(color)
            }
            Text(label).font(AppFonts.caption2).foregroundColor(AppColors.textTertiary)
        }
    }
}

#Preview("ProfileCard") {
    ZStack {
        AppColors.background.ignoresSafeArea()
        VStack(spacing: 16) {
            ProfileCard(username: "NexusCodr", handle: "nexuscodr", level: 12, rank: "Cyber Warrior", xp: 8420, streak: 14, isCurrentUser: true)
            ProfileCard(username: "QuantumBit", handle: "quantumbit", level: 9, rank: "Code Knight", xp: 5100, streak: 7)
        }.padding()
    }
}
