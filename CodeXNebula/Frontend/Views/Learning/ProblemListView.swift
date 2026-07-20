//
//  ProblemListView.swift
//  CodeXNebula
//
//  Screen for displaying coding problems in a chapter.
//

import SwiftUI

struct ProblemListView: View {
    let chapter: Chapter
    @ObservedObject var viewModel: LearningViewModel
    
    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: AppSpacing.md) {
                    
                    // Header
                    VStack(alignment: .leading, spacing: AppSpacing.sm) {
                        Text(chapter.title)
                            .appFont(AppFonts.title2)
                            .foregroundColor(AppColors.textPrimary)
                        
                        Text("Solve these challenges to earn XP.")
                            .appFont(AppFonts.body)
                            .foregroundColor(AppColors.textSecondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, AppSpacing.xl)
                    .padding(.top, AppSpacing.lg)
                    .padding(.bottom, AppSpacing.sm)
                    
                    if viewModel.isLoadingProblems {
                        ProgressView()
                            .tint(AppColors.neonCyan)
                            .padding(.top, 50)
                    } else {
                            if let language = viewModel.selectedLanguage {
                                ForEach(viewModel.problems) { problem in
                                    NavigationLink(value: CodingDestination.detail(problem: problem, language: language)) {
                                        ProblemRow(problem: problem)
                                    }
                                }
                                .padding(.horizontal, AppSpacing.xl)
                            }
                    }
                    
                    Spacer(minLength: 40)
                }
            }
        }
        .navigationTitle("Problems")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.selectChapter(chapter)
        }
    }
}

// MARK: - ProblemRow

struct ProblemRow: View {
    let problem: CodingProblem
    
    var body: some View {
        GlassCard {
            HStack(spacing: AppSpacing.md) {
                // Status Icon
                ZStack {
                    Circle()
                        .fill(problem.isCompleted ? AppColors.success.opacity(0.1) : AppColors.cardBackground)
                        .frame(width: 48, height: 48)
                        .overlay(
                            Circle().stroke(problem.isCompleted ? AppColors.success : AppColors.textTertiary.opacity(0.3), lineWidth: 1)
                        )
                    
                    Image(systemName: problem.isCompleted ? "checkmark" : "lock.open.fill")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(problem.isCompleted ? AppColors.success : AppColors.textTertiary)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(problem.title)
                        .appFont(AppFonts.headline)
                        .foregroundColor(AppColors.textPrimary)
                    
                    HStack(spacing: AppSpacing.sm) {
                        // Difficulty Badge
                        Text(problem.difficulty.rawValue)
                            .font(AppFonts.caption)
                            .foregroundColor(problem.difficulty.color)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(problem.difficulty.color.opacity(0.1))
                            .cornerRadius(4)
                        
                        // XP Badge
                        HStack(spacing: 2) {
                            Image(systemName: "star.fill")
                                .font(.system(size: 10))
                            Text("+\(problem.xpReward) XP")
                        }
                        .font(AppFonts.caption)
                        .foregroundColor(AppColors.warning)
                    }
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(AppColors.textTertiary)
            }
            .padding(AppSpacing.md)
        }
    }
}
