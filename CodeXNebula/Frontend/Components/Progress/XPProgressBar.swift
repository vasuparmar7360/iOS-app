//
//  XPProgressBar.swift
//  CodeXNebula
//
//  Animated horizontal progress bar for XP and level progression.
//  Uses the gradient XP colour by default; fully customisable.
//

import SwiftUI

struct XPProgressBar: View {
    /// 0.0 – 1.0
    let progress: Double
    var color: LinearGradient    = AppColors.gradientXP
    var trackColor: Color        = AppColors.cardBackground
    var cornerRadius: CGFloat    = AppRadius.pill
    var showGlow: Bool           = true
    var animated: Bool           = true

    @State private var animatedProgress: Double = 0

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                // Track
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(trackColor)
                    .overlay(
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .strokeBorder(AppColors.borderSubtle, lineWidth: 1)
                    )

                // Fill
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(color)
                    .frame(width: max(0, geo.size.width * animatedProgress))
                    .if(showGlow) { v in
                        v.shadow(color: AppColors.neonPurple.opacity(0.55),
                                 radius: 8, x: 0, y: 0)
                    }

                // Shimmer highlight
                if animatedProgress > 0.05 {
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(
                            LinearGradient(
                                colors: [.white.opacity(0.18), .clear],
                                startPoint: .top, endPoint: .bottom
                            )
                        )
                        .frame(width: max(0, geo.size.width * animatedProgress))
                }
            }
        }
        .onAppear {
            if animated {
                withAnimation(AppAnimation.progress.delay(0.1)) {
                    animatedProgress = min(max(progress, 0), 1)
                }
            } else {
                animatedProgress = progress
            }
        }
        .onChange(of: progress) { _, newValue in
            withAnimation(AppAnimation.progress) {
                animatedProgress = min(max(newValue, 0), 1)
            }
        }
    }
}

// MARK: - View+if helper
extension View {
    @ViewBuilder
    func `if`<T: View>(_ condition: Bool, transform: (Self) -> T) -> some View {
        if condition { transform(self) } else { self }
    }
}

#Preview("XPProgressBar") {
    ZStack {
        AppColors.background.ignoresSafeArea()
        VStack(spacing: 24) {
            VStack(alignment: .leading, spacing: 6) {
                Text("XP Progress — 68%").font(AppFonts.caption).foregroundColor(AppColors.textSecondary)
                XPProgressBar(progress: 0.68).frame(height: 10)
            }
            VStack(alignment: .leading, spacing: 6) {
                Text("Mission Progress — 35%").font(AppFonts.caption).foregroundColor(AppColors.textSecondary)
                XPProgressBar(progress: 0.35, color: AppColors.gradientCyan).frame(height: 8)
            }
            VStack(alignment: .leading, spacing: 6) {
                Text("Full — 100%").font(AppFonts.caption).foregroundColor(AppColors.textSecondary)
                XPProgressBar(progress: 1.0).frame(height: 12)
            }
        }
        .padding()
    }
}
