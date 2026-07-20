//
//  XPCard.swift
//  CodeXNebula
//
//  Displays the user's XP, level, and XP progress toward the next level.
//  Used in profile summaries, post-mission screens, and the dashboard.
//

import SwiftUI

// MARK: - XPCard

struct XPCard: View {

    let currentXP: Int
    let nextLevelXP: Int
    let level: Int
    var title: String = "Experience Points"

    private var progress: Double {
        guard nextLevelXP > 0 else { return 0 }
        return min(Double(currentXP) / Double(nextLevelXP), 1.0)
    }

    // -------------------------------------------------------------------------
    var body: some View {
        GlassCard(
            borderColor: AppColors.neonPurple.opacity(0.35),
            glowColor: AppColors.neonPurple
        ) {
            VStack(alignment: .leading, spacing: AppSpacing.md) {

                // Header row
                HStack {
                    VStack(alignment: .leading, spacing: AppSpacing.xxs) {
                        Text(title)
                            .font(AppFonts.caption)
                            .foregroundColor(AppColors.textSecondary)
                            .tracking(1.5)
                            .textCase(.uppercase)

                        HStack(alignment: .firstTextBaseline, spacing: 4) {
                            Text("\(currentXP)")
                                .font(AppFonts.xpText)
                                .foregroundColor(AppColors.neonPurple)

                            Text("/ \(nextLevelXP) XP")
                                .font(AppFonts.footnote)
                                .foregroundColor(AppColors.textSecondary)
                        }
                    }

                    Spacer()

                    // Level badge
                    ZStack {
                        Circle()
                            .fill(AppColors.gradientXP)
                            .frame(width: 52, height: 52)
                            .shadow(color: AppColors.neonPurple.opacity(0.5),
                                    radius: 12, x: 0, y: 0)

                        VStack(spacing: 0) {
                            Text("LVL")
                                .font(AppFonts.caption2)
                                .foregroundColor(.white.opacity(0.75))
                            Text("\(level)")
                                .font(AppFonts.scoreMedium)
                                .foregroundColor(.white)
                        }
                    }
                }

                // XP Progress bar
                XPProgressBar(
                    progress: progress,
                    color: AppColors.gradientXP
                )
                .frame(height: 8)

                // Footer
                HStack {
                    Image(systemName: AppIcon.xp)
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(AppColors.neonPurple)
                    Text("\(nextLevelXP - currentXP) XP to Level \(level + 1)")
                        .font(AppFonts.caption)
                        .foregroundColor(AppColors.textSecondary)
                    Spacer()
                    Text(String(format: "%.0f%%", progress * 100))
                        .font(AppFonts.caption)
                        .foregroundColor(AppColors.neonPurple)
                }
            }
        }
    }
}

// MARK: - Preview

#Preview("XPCard") {
    ZStack {
        AppColors.background.ignoresSafeArea()
        VStack(spacing: 20) {
            XPCard(currentXP: 2450, nextLevelXP: 3000, level: 7)
            XPCard(currentXP: 150,  nextLevelXP: 500,  level: 1,
                   title: "Beginner XP")
        }
        .padding()
    }
}
