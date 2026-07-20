//
//  SocialLoginButton.swift
//  CodeXNebula
//
//  Button component for Apple and Google sign-in options.
//

import SwiftUI

enum SocialPlatform {
    case apple
    case google
    
    var icon: String {
        switch self {
        case .apple: return "applelogo"
        case .google: return "g.circle.fill" // SF Symbol approximation for Google
        }
    }
    
    var title: String {
        switch self {
        case .apple: return "Continue with Apple"
        case .google: return "Continue with Google"
        }
    }
}

struct SocialLoginButton: View {
    let platform: SocialPlatform
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: AppSpacing.sm) {
                Image(systemName: platform.icon)
                    .font(.system(size: 20))
                Text(platform.title)
                    .font(AppFonts.buttonPrimary)
            }
            .foregroundColor(AppColors.textPrimary)
            .frame(maxWidth: .infinity)
            .padding(.vertical, AppSpacing.sm + 2)
            .background(AppColors.cardBackground)
            .cornerRadius(AppRadius.button)
            .overlay(
                RoundedRectangle(cornerRadius: AppRadius.button)
                    .strokeBorder(AppColors.borderSubtle, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
        .pressAnimation()
    }
}

#Preview {
    ZStack {
        AppColors.background.ignoresSafeArea()
        VStack(spacing: 16) {
            SocialLoginButton(platform: .apple) {}
            SocialLoginButton(platform: .google) {}
        }
        .padding()
    }
}
