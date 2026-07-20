//
//  CircularProgressView.swift
//  CodeXNebula
//
//  An animated circular arc progress indicator with
//  a centre value label and optional neon glow.
//

import SwiftUI

struct CircularProgressView: View {
    /// 0.0 – 1.0
    let progress: Double
    var lineWidth: CGFloat      = 8
    var size: CGFloat           = 80
    var trackColor: Color       = AppColors.cardBackground
    var progressColor: Color    = AppColors.neonCyan
    var glowColor: Color?       = AppColors.neonCyan
    var label: String?          = nil
    var sublabel: String?       = nil

    @State private var animatedProgress: Double = 0

    private var angle: Double { animatedProgress * 360 }

    var body: some View {
        ZStack {
            // Track ring
            Circle()
                .stroke(trackColor, lineWidth: lineWidth)

            // Progress arc
            Circle()
                .trim(from: 0, to: animatedProgress)
                .stroke(
                    progressColor,
                    style: StrokeStyle(
                        lineWidth: lineWidth,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))
                .if(glowColor != nil) { v in
                    v.shadow(color: (glowColor ?? .clear).opacity(0.6),
                             radius: 8, x: 0, y: 0)
                }

            // Centre content
            VStack(spacing: 1) {
                if let label {
                    Text(label)
                        .font(size > 70 ? AppFonts.scoreMedium : AppFonts.caption)
                        .foregroundColor(progressColor)
                }
                if let sublabel {
                    Text(sublabel)
                        .font(AppFonts.caption2)
                        .foregroundColor(AppColors.textSecondary)
                }
            }
        }
        .frame(width: size, height: size)
        .onAppear {
            withAnimation(AppAnimation.progress.delay(0.15)) {
                animatedProgress = min(max(progress, 0), 1)
            }
        }
        .onChange(of: progress) { _, newValue in
            withAnimation(AppAnimation.progress) {
                animatedProgress = min(max(newValue, 0), 1)
            }
        }
    }
}

#Preview("CircularProgressView") {
    ZStack {
        AppColors.background.ignoresSafeArea()
        HStack(spacing: 32) {
            CircularProgressView(progress: 0.72,
                                 label: "72%", sublabel: "Complete")
            CircularProgressView(progress: 0.45,
                                 size: 64,
                                 progressColor: AppColors.neonPurple,
                                 glowColor: AppColors.neonPurple,
                                 label: "45%")
            CircularProgressView(progress: 1.0,
                                 progressColor: AppColors.success,
                                 glowColor: AppColors.success,
                                 label: "✓")
        }
    }
}
