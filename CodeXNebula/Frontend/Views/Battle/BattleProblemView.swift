//
//  BattleProblemView.swift
//  CodeXNebula
//

import SwiftUI

struct BattleProblemView: View {
    let problem: BattleProblem
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppSpacing.md) {
                Text(problem.title)
                    .appFont(AppFonts.title2)
                    .foregroundColor(AppColors.neonCyan)
                
                HStack {
                    Text(problem.difficulty.rawValue)
                        .font(AppFonts.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(problem.difficulty.color.opacity(0.15))
                        .foregroundColor(problem.difficulty.color)
                        .cornerRadius(4)
                }
                
                Text(problem.description)
                    .appFont(AppFonts.body)
                    .foregroundColor(AppColors.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
                
                Spacer(minLength: 20)
            }
            .padding(AppSpacing.md)
        }
        .background(AppColors.backgroundSecondary)
    }
}
