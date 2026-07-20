//
//  ProblemDetailView.swift
//  CodeXNebula
//
//  Displays problem details (description, constraints, IO).
//

import SwiftUI

struct ProblemDetailView: View {
    let problem: CodingProblem
    let language: Language
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppSpacing.lg) {
                // Header
                VStack(alignment: .leading, spacing: AppSpacing.sm) {
                    Text(problem.title)
                        .font(AppFonts.title)
                        .foregroundColor(AppColors.textPrimary)
                    
                    HStack(spacing: AppSpacing.sm) {
                        Text(problem.difficulty.rawValue)
                            .font(AppFonts.caption)
                            .foregroundColor(problem.difficulty.color)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(problem.difficulty.color.opacity(0.15))
                            .cornerRadius(4)
                        
                        Text("+\(problem.xpReward) XP")
                            .font(AppFonts.caption)
                            .foregroundColor(AppColors.warning)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(AppColors.warning.opacity(0.15))
                            .cornerRadius(4)
                        
                        Spacer()
                    }
                }
                
                Divider().background(AppColors.borderSubtle)
                
                // Description
                VStack(alignment: .leading, spacing: AppSpacing.sm) {
                    Text("Description")
                        .font(AppFonts.headline)
                        .foregroundColor(AppColors.textPrimary)
                    
                    Text(problem.description)
                        .font(AppFonts.body)
                        .foregroundColor(AppColors.textSecondary)
                        .lineSpacing(4)
                }
                
                // Sample I/O
                if let sampleInput = problem.sampleInput, let sampleOutput = problem.sampleOutput {
                    VStack(alignment: .leading, spacing: AppSpacing.md) {
                        Text("Example")
                            .font(AppFonts.headline)
                            .foregroundColor(AppColors.textPrimary)
                        
                        GlassCard(padding: AppSpacing.sm, glowColor: AppColors.neonCyan.opacity(0.3)) {
                            VStack(alignment: .leading, spacing: AppSpacing.xs) {
                                Text("Input:")
                                    .font(AppFonts.caption)
                                    .foregroundColor(AppColors.textSecondary)
                                Text(sampleInput)
                                    .font(AppFonts.code)
                                    .foregroundColor(AppColors.textPrimary)
                                    .padding(.bottom, AppSpacing.xs)
                                
                                Text("Output:")
                                    .font(AppFonts.caption)
                                    .foregroundColor(AppColors.textSecondary)
                                Text(sampleOutput)
                                    .font(AppFonts.code)
                                    .foregroundColor(AppColors.textPrimary)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                }
                
                // Constraints
                if let constraints = problem.constraints, !constraints.isEmpty {
                    VStack(alignment: .leading, spacing: AppSpacing.sm) {
                        Text("Constraints")
                            .font(AppFonts.headline)
                            .foregroundColor(AppColors.textPrimary)
                        
                        ForEach(constraints, id: \.self) { constraint in
                            HStack(alignment: .top) {
                                Text("•")
                                    .foregroundColor(AppColors.textSecondary)
                                Text(constraint)
                                    .font(AppFonts.codeSmall)
                                    .foregroundColor(AppColors.textSecondary)
                            }
                        }
                    }
                }
                
                // Solve Button
                NavigationLink(value: CodingDestination.editor(problem: problem, language: language)) {
                    Text("Solve Problem")
                        .font(AppFonts.buttonPrimary)
                        .foregroundColor(AppColors.textPrimary)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(AppColors.neonCyan.opacity(0.2))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(AppColors.neonCyan, lineWidth: 1)
                        )
                        .shadow(color: AppColors.neonCyan.opacity(0.3), radius: 8, x: 0, y: 0)
                }
                .padding(.top, AppSpacing.md)
            }
            .padding(AppSpacing.md)
        }
        .background(AppColors.background)
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }
}
