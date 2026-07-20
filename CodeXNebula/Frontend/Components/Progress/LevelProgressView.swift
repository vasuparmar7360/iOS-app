//
//  LevelProgressView.swift
//  CodeXNebula
//
//  Composite progress view for the level system — shows current level,
//  next level, XP bar, and milestone markers. Used in profile/dashboard.
//

import SwiftUI

struct LevelProgressView: View {
    let currentLevel: Int
    let currentXP: Int
    let nextLevelXP: Int
    var showMilestones: Bool = true

    private var progress: Double {
        guard nextLevelXP > 0 else { return 0 }
        return min(Double(currentXP) / Double(nextLevelXP), 1.0)
    }

    var body: some View {
        VStack(spacing: AppSpacing.sm) {

            // Level indicators row
            HStack {
                // Current level
                levelBadge(level: currentLevel, isActive: true)

                Spacer()

                // XP centre label
                VStack(spacing: 2) {
                    Text("\(currentXP) / \(nextLevelXP) XP")
                        .font(AppFonts.caption)
                        .foregroundColor(AppColors.textSecondary)
                    Text(String(format: "%.0f%%", progress * 100))
                        .font(AppFonts.statLabel)
                        .foregroundColor(AppColors.neonPurple)
                }

                Spacer()

                // Next level
                levelBadge(level: currentLevel + 1, isActive: false)
            }

            // Progress bar
            ZStack(alignment: .leading) {
                XPProgressBar(progress: progress, color: AppColors.gradientXP)
                    .frame(height: 12)

                // Milestone markers at 25%, 50%, 75%
                if showMilestones {
                    GeometryReader { geo in
                        ForEach([0.25, 0.50, 0.75], id: \.self) { pct in
                            Rectangle()
                                .fill(AppColors.background.opacity(0.5))
                                .frame(width: 1.5, height: 12)
                                .offset(x: geo.size.width * pct - 0.75)
                        }
                    }
                    .frame(height: 12)
                }
            }

            // Remaining XP label
            HStack {
                Image(systemName: AppIcon.xp)
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(AppColors.neonPurple)
                Text("\(max(0, nextLevelXP - currentXP)) XP remaining to Level \(currentLevel + 1)")
                    .font(AppFonts.caption)
                    .foregroundColor(AppColors.textSecondary)
                Spacer()
            }
        }
    }

    private func levelBadge(level: Int, isActive: Bool) -> some View {
        ZStack {
            Group {
                if isActive {
                    RoundedRectangle(cornerRadius: AppRadius.md)
                        .fill(AppColors.gradientXP)
                } else {
                    RoundedRectangle(cornerRadius: AppRadius.md)
                        .fill(AppColors.cardBackground)
                }
            }
            .frame(width: 48, height: 48)
            .shadow(
                color: isActive ? AppColors.neonPurple.opacity(0.4) : .clear,
                radius: 8
            )
            .overlay(
                RoundedRectangle(cornerRadius: AppRadius.md)
                    .strokeBorder(
                        isActive ? Color.clear : AppColors.borderSubtle,
                        lineWidth: 1
                    )
            )

            VStack(spacing: 0) {
                Text("LVL").font(AppFonts.caption2)
                    .foregroundColor(isActive ? .white.opacity(0.7) : AppColors.textTertiary)
                Text("\(level)").font(AppFonts.scoreMedium)
                    .foregroundColor(isActive ? .white : AppColors.textSecondary)
            }
        }
    }
}

#Preview("LevelProgressView") {
    ZStack {
        AppColors.background.ignoresSafeArea()
        VStack(spacing: 24) {
            LevelProgressView(currentLevel: 7, currentXP: 2450, nextLevelXP: 3000)
            LevelProgressView(currentLevel: 1, currentXP: 80,   nextLevelXP: 500, showMilestones: false)
        }
        .padding()
    }
}
