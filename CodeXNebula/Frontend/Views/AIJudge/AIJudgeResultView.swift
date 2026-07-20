//
//  AIJudgeResultView.swift
//  CodeXNebula
//

import SwiftUI

struct AIJudgeResultView: View {
    let player1Code: String
    let player2Code: String
    @StateObject private var viewModel = AIJudgeViewModel()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()
            
            if viewModel.isLoading {
                VStack(spacing: AppSpacing.md) {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: AppColors.neonPurple))
                        .scaleEffect(1.5)
                    Text("AI Judge is analyzing the battle...")
                        .font(AppFonts.headline)
                        .foregroundColor(AppColors.neonPurple)
                }
            } else if let evaluation = viewModel.evaluation {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: AppSpacing.xl) {
                        
                        // Winner Announcement
                        VStack(spacing: AppSpacing.sm) {
                            Text("WINNER")
                                .font(.system(size: 24, weight: .bold, design: .monospaced))
                                .foregroundColor(AppColors.neonCyan)
                            Text(evaluation.decision.winnerId == "currentUser" ? evaluation.player1Score.username : evaluation.player2Score.username)
                                .font(.system(size: 40, weight: .black, design: .default))
                                .foregroundColor(AppColors.textPrimary)
                                .shadow(color: AppColors.neonCyan.opacity(0.5), radius: 10)
                            
                            Text(evaluation.decision.victoryReason)
                                .font(AppFonts.body)
                                .foregroundColor(AppColors.textSecondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                        }
                        
                        // Score Comparison
                        HStack(spacing: AppSpacing.md) {
                            PlayerScoreCard(score: evaluation.player1Score)
                            PlayerScoreCard(score: evaluation.player2Score)
                        }
                        .padding(.horizontal)
                        
                        // Performance Analysis
                        PerformanceAnalysisView(player1Score: evaluation.player1Score, player2Score: evaluation.player2Score)
                        
                        // Code Comparison
                        CodeComparisonView(player1Code: evaluation.player1Score.code, player2Code: evaluation.player2Score.code)
                        
                        Spacer(minLength: 20)
                        
                        PrimaryButton(title: "Return to Lobby", icon: "house.fill") {
                            // This would ideally pop back to the root NavigationStack
                        }
                        .padding(.horizontal)
                        .padding(.bottom, AppSpacing.xl)
                    }
                    .padding(.top, AppSpacing.xl)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("AI Judge Decision")
        .task {
            await viewModel.generateEvaluation(player1Code: player1Code, player2Code: player2Code)
        }
    }
}

struct PlayerScoreCard: View {
    let score: PlayerScore
    
    var body: some View {
        GlassCard(padding: AppSpacing.md) {
            VStack(spacing: AppSpacing.md) {
                Text(score.username)
                    .font(AppFonts.headline)
                    .foregroundColor(score.isWinner ? AppColors.neonCyan : AppColors.textPrimary)
                
                Text("\(score.metrics.totalScore)")
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .foregroundColor(score.isWinner ? AppColors.success : AppColors.warning)
                
                Text("Score")
                    .font(AppFonts.caption)
                    .foregroundColor(AppColors.textSecondary)
                
                Divider().background(AppColors.borderSubtle)
                
                HStack {
                    Text("+\(score.xpAwarded) XP")
                        .font(AppFonts.headline)
                        .foregroundColor(AppColors.neonPurple)
                }
            }
            .frame(maxWidth: .infinity)
        }
        .overlay(
            RoundedRectangle(cornerRadius: AppRadius.card)
                .stroke(score.isWinner ? AppColors.neonCyan : AppColors.borderSubtle, lineWidth: score.isWinner ? 2 : 1)
        )
    }
}
