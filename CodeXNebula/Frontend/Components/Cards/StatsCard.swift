//
//  StatsCard.swift
//  CodeXNebula
//
//  A compact single-stat tile — used in grids to show metrics
//  like problems solved, win rate, streak, accuracy, etc.
//

import SwiftUI

struct StatsCard: View {
    let value: String
    let label: String
    let icon: String
    var iconColor: Color  = AppColors.neonCyan
    var trend: String?    = nil   // e.g. "+12%"
    var trendUp: Bool     = true

    var body: some View {
        GlassCard(
            cornerRadius: AppRadius.card,
            borderColor: iconColor.opacity(0.20),
            padding: AppSpacing.md
        ) {
            VStack(alignment: .leading, spacing: AppSpacing.sm) {
                // Icon + trend row
                HStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: AppRadius.md)
                            .fill(iconColor.opacity(0.12))
                            .frame(width: 36, height: 36)
                        Image(systemName: icon)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(iconColor)
                    }
                    Spacer()
                    if let trend {
                        HStack(spacing: 2) {
                            Image(systemName: trendUp ? "arrow.up.right" : "arrow.down.right")
                                .font(.system(size: 9, weight: .bold))
                            Text(trend)
                                .font(AppFonts.caption2)
                        }
                        .foregroundColor(trendUp ? AppColors.success : AppColors.error)
                        .padding(.horizontal, 6).padding(.vertical, 3)
                        .background(
                            Capsule().fill(
                                (trendUp ? AppColors.success : AppColors.error).opacity(0.12)
                            )
                        )
                    }
                }

                // Value
                Text(value)
                    .font(AppFonts.xpText)
                    .foregroundColor(iconColor)

                // Label
                Text(label)
                    .font(AppFonts.caption)
                    .foregroundColor(AppColors.textSecondary)
            }
        }
    }
}

// MARK: - Stats Grid Helper

struct StatsGrid: View {
    let stats: [(value: String, label: String, icon: String, color: Color)]

    let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        LazyVGrid(columns: columns, spacing: AppSpacing.cardSpacing) {
            ForEach(stats.indices, id: \.self) { i in
                let s = stats[i]
                StatsCard(value: s.value, label: s.label, icon: s.icon, iconColor: s.color)
            }
        }
    }
}

#Preview("StatsCard") {
    ZStack {
        AppColors.background.ignoresSafeArea()
        StatsGrid(stats: [
            ("142",  "Problems Solved", AppIcon.checkmark, AppColors.success),
            ("14d",  "Day Streak",      AppIcon.streak,    AppColors.warning),
            ("8,420","Total XP",        AppIcon.xp,        AppColors.neonPurple),
            ("72%",  "Win Rate",        AppIcon.trophy,    AppColors.neonCyan)
        ])
        .padding()
    }
}
