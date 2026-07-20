//
//  ProblemCard.swift
//  CodeXNebula
//
//  Displays a coding problem — used in problem lists, battle mode,
//  and mission detail screens.
//

import SwiftUI

// MARK: - ProblemCard

struct ProblemCard: View {

    let number: Int
    let title: String
    let tags: [String]
    let difficulty: MissionDifficulty
    let xpReward: Int
    var isSolved: Bool      = false
    var successRate: Double = 0.72          // 0.0 – 1.0
    var action: (() -> Void)? = nil

    @State private var isPressed = false

    // -------------------------------------------------------------------------
    var body: some View {
        Button(action: { action?() }) {
            HStack(spacing: AppSpacing.md) {

                // Problem number column
                VStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: AppRadius.md)
                            .fill(isSolved
                                  ? AppColors.success.opacity(0.15)
                                  : AppColors.cardBackground)
                            .frame(width: 46, height: 46)
                            .overlay(
                                RoundedRectangle(cornerRadius: AppRadius.md)
                                    .strokeBorder(
                                        isSolved
                                            ? AppColors.success.opacity(0.5)
                                            : AppColors.borderSubtle,
                                        lineWidth: 1
                                    )
                            )

                        if isSolved {
                            Image(systemName: AppIcon.checkmark)
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(AppColors.success)
                        } else {
                            Text("#\(number)")
                                .font(AppFonts.statLabel)
                                .foregroundColor(AppColors.textSecondary)
                        }
                    }
                    Spacer()
                }

                // Content column
                VStack(alignment: .leading, spacing: AppSpacing.xs) {

                    // Title row
                    HStack {
                        Text(title)
                            .font(AppFonts.headline)
                            .foregroundColor(AppColors.textPrimary)
                            .lineLimit(2)
                        Spacer()
                    }

                    // Tags
                    if !tags.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 6) {
                                ForEach(tags, id: \.self) { tag in
                                    Text(tag)
                                        .font(AppFonts.codeSmall)
                                        .foregroundColor(AppColors.blueAccent)
                                        .padding(.horizontal, 7)
                                        .padding(.vertical, 3)
                                        .background(
                                            Capsule()
                                                .fill(AppColors.blueAccent.opacity(0.10))
                                        )
                                }
                            }
                        }
                    }

                    // Footer: difficulty + success rate + XP
                    HStack(spacing: AppSpacing.sm) {
                        // Difficulty dot
                        Circle()
                            .fill(difficulty.color)
                            .frame(width: 7, height: 7)
                        Text(difficulty.rawValue)
                            .font(AppFonts.caption)
                            .foregroundColor(difficulty.color)

                        Spacer()

                        // Success rate
                        Text(String(format: "%.0f%% pass", successRate * 100))
                            .font(AppFonts.caption)
                            .foregroundColor(AppColors.textTertiary)

                        // XP
                        HStack(spacing: 3) {
                            Image(systemName: AppIcon.xp)
                                .font(.system(size: 10))
                                .foregroundColor(AppColors.neonPurple)
                            Text("+\(xpReward)")
                                .font(AppFonts.caption)
                                .foregroundColor(AppColors.neonPurple)
                        }
                    }
                }
            }
            .padding(AppSpacing.md)
            .background(
                RoundedRectangle(cornerRadius: AppRadius.card)
                    .fill(AppColors.cardBackground)
            )
            .overlay(
                RoundedRectangle(cornerRadius: AppRadius.card)
                    .strokeBorder(
                        isSolved
                            ? AppColors.success.opacity(0.30)
                            : AppColors.borderSubtle,
                        lineWidth: 1
                    )
            )
            .cardShadow()
            .scaleEffect(isPressed ? 0.98 : 1.0)
            .animation(AppAnimation.snappy, value: isPressed)
        }
        .buttonStyle(.plain)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isPressed = true }
                .onEnded   { _ in isPressed = false }
        )
    }
}

// MARK: - Preview

#Preview("ProblemCard") {
    ZStack {
        AppColors.background.ignoresSafeArea()
        VStack(spacing: 12) {
            ProblemCard(
                number: 1,
                title: "Two Sum",
                tags: ["Array", "HashMap"],
                difficulty: .easy,
                xpReward: 100
            )
            ProblemCard(
                number: 2,
                title: "Longest Palindromic Substring",
                tags: ["String", "Dynamic Programming", "Two Pointers"],
                difficulty: .medium,
                xpReward: 250,
                isSolved: true,
                successRate: 0.48
            )
        }
        .padding()
    }
}
