//
//  PerformanceAnalysisView.swift
//  CodeXNebula
//

import SwiftUI

struct PerformanceAnalysisView: View {
    let player1Score: PlayerScore
    let player2Score: PlayerScore
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            Text("Performance Analysis")
                .appFont(AppFonts.title2)
                .foregroundColor(AppColors.textPrimary)
                .padding(.horizontal)
            
            GlassCard(padding: AppSpacing.md) {
                VStack(spacing: AppSpacing.md) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Time Complexity")
                                .font(AppFonts.caption)
                                .foregroundColor(AppColors.textSecondary)
                            Text(player1Score.estimatedTimeComplexity)
                                .font(AppFonts.code)
                                .foregroundColor(AppColors.neonCyan)
                        }
                        Spacer()
                        VStack(alignment: .trailing, spacing: 4) {
                            Text("Space Complexity")
                                .font(AppFonts.caption)
                                .foregroundColor(AppColors.textSecondary)
                            Text(player1Score.estimatedSpaceComplexity)
                                .font(AppFonts.code)
                                .foregroundColor(AppColors.neonPurple)
                        }
                    }
                    
                    Divider().background(AppColors.borderSubtle)
                    
                    VStack(alignment: .leading, spacing: AppSpacing.sm) {
                        Text("AI Suggestions")
                            .font(AppFonts.headline)
                            .foregroundColor(AppColors.textPrimary)
                        
                        ForEach(player1Score.optimizationSuggestions, id: \.self) { suggestion in
                            HStack(alignment: .top) {
                                Image(systemName: "sparkles")
                                    .foregroundColor(AppColors.neonPurple)
                                Text(suggestion)
                                    .font(AppFonts.body)
                                    .foregroundColor(AppColors.textSecondary)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding(.horizontal)
        }
    }
}
