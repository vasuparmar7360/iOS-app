//
//  LoadingView.swift
//  CodeXNebula
//

import SwiftUI

struct LoadingView: View {
    var title: String = "Loading..."
    @State private var isAnimating = false
    
    var body: some View {
        GlassCard(padding: AppSpacing.xl, glowColor: AppColors.neonCyan.opacity(0.3)) {
            VStack(spacing: AppSpacing.md) {
                Circle()
                    .trim(from: 0, to: 0.75)
                    .stroke(AppColors.neonCyan, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                    .frame(width: 48, height: 48)
                    .rotationEffect(Angle(degrees: isAnimating ? 360 : 0))
                    .animation(.linear(duration: 1.2).repeatForever(autoreverses: false), value: isAnimating)
                    .onAppear { isAnimating = true }
                
                Text(title)
                    .font(AppFonts.headline)
                    .foregroundColor(AppColors.textSecondary)
            }
        }
        .fadeIn()
    }
}
