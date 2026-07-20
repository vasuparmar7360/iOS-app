//
//  SplashView.swift
//  CodeXNebula
//
//  The premium futuristic splash screen for CodeX Nebula.
//

import SwiftUI

struct SplashView: View {
    
    @EnvironmentObject private var appState: AppState
    
    // Animation States
    @State private var logoScale: CGFloat = 0.5
    @State private var logoOpacity: Double = 0.0
    @State private var textOpacity: Double = 0.0
    @State private var textOffset: CGFloat = 40
    @State private var buttonOpacity: Double = 0.0
    
    // Particle System States
    @State private var particleRotation: Double = 0
    @State private var pulseGlow: Bool = false
    
    var body: some View {
        ZStack {
            // 1. BACKGROUND
            AppColors.background
                .ignoresSafeArea()
            
            // Nebula Background Gradient
            RadialGradient(
                colors: [
                    AppColors.neonPurple.opacity(0.15),
                    AppColors.background
                ],
                center: .center,
                startRadius: 50,
                endRadius: 400
            )
            .ignoresSafeArea()
            
            // Animated Particles (Simple abstraction for futuristic vibe)
            ZStack {
                ForEach(0..<12) { i in
                    Circle()
                        .fill(AppColors.neonCyan.opacity(0.3))
                        .frame(width: CGFloat.random(in: 2...6), height: CGFloat.random(in: 2...6))
                        .offset(
                            x: CGFloat.random(in: -150...150),
                            y: CGFloat.random(in: -250...250)
                        )
                        .rotationEffect(.degrees(particleRotation))
                        .opacity(pulseGlow ? 0.8 : 0.2)
                        .animation(
                            Animation.easeInOut(duration: Double.random(in: 2...4))
                                .repeatForever(autoreverses: true)
                                .delay(Double.random(in: 0...2)),
                            value: pulseGlow
                        )
                }
            }
            
            VStack(spacing: AppSpacing.xxl) {
                Spacer()
                
                // 2. LOGO
                ZStack {
                    // Outer glow rings
                    Circle()
                        .strokeBorder(AppColors.neonCyan.opacity(0.2), lineWidth: 1)
                        .frame(width: 140, height: 140)
                        .scaleEffect(pulseGlow ? 1.1 : 0.9)
                    
                    Circle()
                        .fill(AppColors.gradientPrimary)
                        .frame(width: 100, height: 100)
                        .shadow(color: AppColors.neonCyan.opacity(0.6), radius: pulseGlow ? 25 : 15)
                    
                    // Core Icon
                    Image(systemName: AppIcon.code)
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(.white)
                }
                .scaleEffect(logoScale)
                .opacity(logoOpacity)
                
                // 3. APP TITLE & 4. TAGLINE
                VStack(spacing: AppSpacing.sm) {
                    Text("CodeX Nebula")
                        .appFont(AppFonts.largeTitle)
                        .foregroundColor(AppColors.textPrimary)
                        .shadow(color: AppColors.neonPurple.opacity(0.5), radius: 10)
                    
                    Text("Level Up Your Coding Journey")
                        .appFont(AppFonts.subheadline)
                        .foregroundColor(AppColors.textSecondary)
                        .tracking(1.5)
                }
                .opacity(textOpacity)
                .offset(y: textOffset)
                
                Spacer()
                
                // 5. LAUNCH BUTTON
                PrimaryButton(
                    title: "Launch Protocol",
                    icon: AppIcon.run,
                    fullWidth: false
                ) {
                    // 6. NAVIGATION
                    appState.hasCompletedSplash = true
                }
                .padding(.bottom, AppSpacing.xxxl)
                .opacity(buttonOpacity)
            }
        }
        .onAppear {
            startAnimations()
        }
    }
    
    // 7. ANIMATIONS
    private func startAnimations() {
        // Continuous particle rotation and glowing
        withAnimation(.linear(duration: 20).repeatForever(autoreverses: false)) {
            particleRotation = 360
        }
        withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
            pulseGlow = true
        }
        
        // Logo Entrance
        withAnimation(AppAnimation.heroIn.delay(0.3)) {
            logoScale = 1.0
            logoOpacity = 1.0
        }
        
        // Text Entrance
        withAnimation(AppAnimation.screenIn.delay(0.8)) {
            textOpacity = 1.0
            textOffset = 0
        }
        
        // Button Entrance
        withAnimation(AppAnimation.fade.delay(1.5)) {
            buttonOpacity = 1.0
        }
    }
}

#Preview {
    SplashView()
        .environmentObject(AppState())
}
