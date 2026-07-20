//
//  MissionCard.swift
//  CodeXNebula
//
//  Represents a learning mission/challenge in lists and grids.
//  Shows difficulty, language, XP reward, and completion status.
//

import SwiftUI

// MARK: - MissionDifficulty

enum MissionDifficulty: String, CaseIterable {
    case beginner  = "Beginner"
    case easy      = "Easy"
    case medium    = "Medium"
    case hard      = "Hard"
    case expert    = "Expert"

    var color: Color {
        switch self {
        case .beginner: return AppColors.success
        case .easy:     return AppColors.neonCyan
        case .medium:   return AppColors.warning
        case .hard:     return AppColors.error
        case .expert:   return AppColors.neonPurple
        }
    }

    var icon: String {
        switch self {
        case .beginner: return "leaf.fill"
        case .easy:     return "bolt.fill"
        case .medium:   return "flame.fill"
        case .hard:     return "shield.fill"
        case .expert:   return "crown.fill"
        }
    }
}

// MARK: - MissionCard

struct MissionCard: View {

    let title: String
    let description: String
    let difficulty: MissionDifficulty
    let language: String
    let xpReward: Int
    var isCompleted: Bool   = false
    var isLocked: Bool      = false
    var action: (() -> Void)? = nil

    @State private var isPressed = false

    // -------------------------------------------------------------------------
    var body: some View {
        Button(action: { action?() }) {
            GlassCard(
                borderColor: isCompleted
                    ? AppColors.success.opacity(0.40)
                    : difficulty.color.opacity(0.25),
                glowColor: isCompleted ? AppColors.success : nil
            ) {
                VStack(alignment: .leading, spacing: AppSpacing.sm) {

                    // Top row — difficulty + language + status
                    HStack(spacing: AppSpacing.xs) {
                        // Difficulty badge
                        HStack(spacing: 4) {
                            Image(systemName: difficulty.icon)
                                .font(.system(size: 10, weight: .semibold))
                            Text(difficulty.rawValue)
                                .font(AppFonts.caption2)
                        }
                        .foregroundColor(difficulty.color)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            Capsule().fill(difficulty.color.opacity(0.15))
                        )

                        // Language chip
                        Text(language)
                            .font(AppFonts.codeSmall)
                            .foregroundColor(AppColors.blueAccent)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(
                                Capsule().fill(AppColors.blueAccent.opacity(0.12))
                            )

                        Spacer()

                        // Status icon
                        if isLocked {
                            Image(systemName: AppIcon.lock)
                                .font(.system(size: 14))
                                .foregroundColor(AppColors.textTertiary)
                        } else if isCompleted {
                            Image(systemName: AppIcon.checkmark)
                                .font(.system(size: 16))
                                .foregroundColor(AppColors.success)
                        }
                    }

                    // Title
                    Text(title)
                        .font(AppFonts.title3)
                        .foregroundColor(
                            isLocked ? AppColors.textTertiary : AppColors.textPrimary
                        )
                        .lineLimit(2)

                    // Description
                    Text(description)
                        .font(AppFonts.callout)
                        .foregroundColor(AppColors.textSecondary)
                        .lineLimit(2)

                    // XP reward row
                    HStack {
                        Image(systemName: AppIcon.xp)
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(AppColors.neonPurple)
                        Text("+\(xpReward) XP")
                            .font(AppFonts.statLabel)
                            .foregroundColor(AppColors.neonPurple)

                        Spacer()

                        if !isLocked {
                            Image(systemName: AppIcon.forward)
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(AppColors.textTertiary)
                        }
                    }
                }
            }
        }
        .buttonStyle(.plain)
        .disabled(isLocked)
        .scaleEffect(isPressed ? 0.98 : 1.0)
        .animation(AppAnimation.snappy, value: isPressed)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isPressed = true }
                .onEnded   { _ in isPressed = false }
        )
    }
}

// MARK: - Preview

#Preview("MissionCard") {
    ZStack {
        AppColors.background.ignoresSafeArea()
        VStack(spacing: 16) {
            MissionCard(
                title: "Variables & Data Types",
                description: "Learn Swift's type system with hands-on exercises.",
                difficulty: .beginner,
                language: "Swift",
                xpReward: 150
            )
            MissionCard(
                title: "Closures & Higher Order Functions",
                description: "Master map, filter, reduce and closure syntax.",
                difficulty: .medium,
                language: "Swift",
                xpReward: 320,
                isCompleted: true
            )
            MissionCard(
                title: "Concurrency with async/await",
                description: "Unlock after completing intermediate missions.",
                difficulty: .hard,
                language: "Swift",
                xpReward: 500,
                isLocked: true
            )
        }
        .padding()
    }
}
