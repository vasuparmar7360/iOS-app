//
//  XPProgressView.swift
//  CodeXNebula
//

import SwiftUI

struct XPProgressView: View {
    let currentXP: Int
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text("Level \(LevelSystem.level(for: currentXP))")
                    .font(AppFonts.headline)
                    .foregroundColor(AppColors.neonCyan)
                
                Spacer()
                
                let currentLvl = LevelSystem.level(for: currentXP)
                let currentLvlXp = LevelSystem.xpRequired(for: currentLvl)
                let nextLvlXp = LevelSystem.xpRequired(for: currentLvl + 1)
                
                Text("\(currentXP - currentLvlXp) / \(nextLvlXp - currentLvlXp) XP")
                    .font(AppFonts.caption)
                    .foregroundColor(AppColors.textSecondary)
            }
            
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(AppColors.backgroundSecondary)
                        .frame(height: 8)
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(AppColors.gradientPrimary)
                        .frame(width: geo.size.width * CGFloat(LevelSystem.progress(for: currentXP)), height: 8)
                }
            }
            .frame(height: 8)
        }
    }
}
