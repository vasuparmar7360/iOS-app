//
//  BattleResultView.swift
//  CodeXNebula
//

import SwiftUI

struct BattleResultView: View {
    let result: BattleResult
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()
            
            VStack(spacing: AppSpacing.xl) {
                Spacer()
                
                // Result Header
                VStack(spacing: AppSpacing.sm) {
                    Text(result.status.uppercased())
                        .font(.system(size: 48, weight: .black, design: .monospaced))
                        .foregroundColor(result.status == "Victory" ? AppColors.success : AppColors.error)
                        .shadow(color: (result.status == "Victory" ? AppColors.success : AppColors.error).opacity(0.5), radius: 20)
                    
                    Text("Battle Concluded")
                        .appFont(AppFonts.title3)
                        .foregroundColor(AppColors.textSecondary)
                }
                
                // Stats Card
                GlassCard(padding: AppSpacing.lg) {
                    VStack(spacing: AppSpacing.md) {
                        HStack {
                            Text("Winner")
                                .font(AppFonts.body)
                                .foregroundColor(AppColors.textSecondary)
                            Spacer()
                            Text(result.winnerId == "currentUser" ? "You" : (result.winnerId ?? "Draw"))
                                .font(AppFonts.headline)
                                .foregroundColor(AppColors.neonCyan)
                        }
                        
                        Divider().background(AppColors.borderSubtle)
                        
                        HStack {
                            Text("XP Earned")
                                .font(AppFonts.body)
                                .foregroundColor(AppColors.textSecondary)
                            Spacer()
                            Text("+\(result.xpEarned) XP")
                                .font(AppFonts.headline)
                                .foregroundColor(AppColors.neonPurple)
                        }
                        
                        Divider().background(AppColors.borderSubtle)
                        
                        HStack {
                            Text("Completion Time")
                                .font(AppFonts.body)
                                .foregroundColor(AppColors.textSecondary)
                            Spacer()
                            Text("\(result.completionTimeSeconds / 60)m \(result.completionTimeSeconds % 60)s")
                                .font(AppFonts.headline)
                                .foregroundColor(AppColors.textPrimary)
                        }
                        
                        Divider().background(AppColors.borderSubtle)
                        
                        HStack {
                            Text("Code Accuracy")
                                .font(AppFonts.body)
                                .foregroundColor(AppColors.textSecondary)
                            Spacer()
                            Text("\(Int(result.accuracyPercentage))%")
                                .font(AppFonts.headline)
                                .foregroundColor(result.accuracyPercentage >= 100 ? AppColors.success : AppColors.warning)
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding(.horizontal, AppSpacing.xl)
                
                Spacer()
                
                PrimaryButton(title: "Return to Lobby", icon: "house.fill") {
                    dismiss()
                }
                .padding(.horizontal, AppSpacing.xl)
                .padding(.bottom, AppSpacing.xl)
            }
        }
        .navigationBarHidden(true)
    }
}
