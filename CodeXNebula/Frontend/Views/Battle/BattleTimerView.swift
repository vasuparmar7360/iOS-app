//
//  BattleTimerView.swift
//  CodeXNebula
//

import SwiftUI

struct BattleTimerView: View {
    let timer: BattleTimer
    
    var body: some View {
        HStack(spacing: AppSpacing.sm) {
            Image(systemName: "timer")
                .foregroundColor(timer.remainingSeconds < 60 ? AppColors.error : AppColors.neonCyan)
            
            Text(timer.timeString)
                .font(AppFonts.codeLarge)
                .foregroundColor(timer.remainingSeconds < 60 ? AppColors.error : AppColors.textPrimary)
                // Pulse effect if under 1 minute
                .opacity(timer.remainingSeconds < 60 && timer.remainingSeconds % 2 == 0 ? 0.6 : 1.0)
                .animation(.linear(duration: 0.5), value: timer.remainingSeconds)
        }
        .padding(.horizontal, AppSpacing.md)
        .padding(.vertical, AppSpacing.sm)
        .background(
            RoundedRectangle(cornerRadius: AppRadius.card)
                .fill(AppColors.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: AppRadius.card)
                        .stroke(timer.remainingSeconds < 60 ? AppColors.error : AppColors.borderSubtle, lineWidth: 1)
                )
        )
    }
}
