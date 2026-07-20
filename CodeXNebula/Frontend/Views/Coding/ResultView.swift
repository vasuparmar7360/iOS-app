//
//  ResultView.swift
//  CodeXNebula
//
//  Displays the final execution result after submission.
//

import SwiftUI

struct ResultView: View {
    let result: ExecutionResult
    let problem: CodingProblem
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xl) {
                // Status Badge
                VStack(spacing: AppSpacing.sm) {
                    Image(systemName: result.status == .accepted ? "checkmark.seal.fill" : "exclamationmark.triangle.fill")
                        .font(.system(size: 64))
                        .foregroundColor(result.status.color)
                        .padding(.top, AppSpacing.xl)
                    
                    Text(result.status.rawValue)
                        .font(AppFonts.largeTitle)
                        .foregroundColor(result.status.color)
                        .multilineTextAlignment(.center)
                    
                    if result.status == .accepted {
                        Text("Excellent work, Nova Coder!")
                            .font(AppFonts.body)
                            .foregroundColor(AppColors.textSecondary)
                    } else {
                        Text("Don't give up. Review the output and try again.")
                            .font(AppFonts.body)
                            .foregroundColor(AppColors.textSecondary)
                            .multilineTextAlignment(.center)
                    }
                }
                
                // Metrics Grid
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: AppSpacing.md) {
                    MetricCard(title: "XP Earned", value: "+\(result.xpEarned)", icon: "star.fill", color: AppColors.warning)
                    MetricCard(title: "Runtime", value: String(format: "%.1f ms", result.executionTimeMs), icon: "timer", color: AppColors.neonCyan)
                    MetricCard(title: "Memory", value: String(format: "%.1f KB", result.memoryUsageKB), icon: "memorychip", color: AppColors.neonPurple)
                    MetricCard(title: "Test Cases", value: "\(result.passedTestCases)/\(result.totalTestCases)", icon: "checklist", color: result.passedTestCases == result.totalTestCases ? AppColors.success : AppColors.error)
                }
                
                // Output/Error Box
                if !result.output.isEmpty || result.errorMessage != nil {
                    VStack(alignment: .leading, spacing: AppSpacing.xs) {
                        Text("Output")
                            .font(AppFonts.headline)
                            .foregroundColor(AppColors.textPrimary)
                        
                        GlassCard(padding: AppSpacing.md) {
                            Text(result.errorMessage ?? result.output)
                                .font(AppFonts.code)
                                .foregroundColor(result.errorMessage != nil ? AppColors.error : AppColors.textSecondary)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                }
                
                // Actions
                PrimaryButton(title: "Continue", icon: "arrow.right", fullWidth: true) {
                    dismiss()
                }
            }
            .padding(AppSpacing.md)
        }
        .background(AppColors.background.ignoresSafeArea())
        .navigationBarHidden(true)
    }
}

struct MetricCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        GlassCard(padding: AppSpacing.md, glowColor: color.opacity(0.2)) {
            VStack(spacing: AppSpacing.sm) {
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(color)
                
                Text(value)
                    .font(AppFonts.title3)
                    .foregroundColor(AppColors.textPrimary)
                
                Text(title)
                    .font(AppFonts.caption)
                    .foregroundColor(AppColors.textSecondary)
            }
            .frame(maxWidth: .infinity)
        }
    }
}
