//
//  ForgotPasswordView.swift
//  CodeXNebula
//
//  Screen for requesting a password reset link.
//

import SwiftUI

struct ForgotPasswordView: View {
    @EnvironmentObject private var appState: AppState
    @StateObject private var viewModel = AuthenticationViewModel()
    @State private var isSuccess = false
    
    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()
            
            VStack(spacing: AppSpacing.xxl) {
                
                // Header
                VStack(spacing: AppSpacing.sm) {
                    Image(systemName: "lock.rotation")
                        .font(.system(size: 48, weight: .light))
                        .foregroundColor(AppColors.neonCyan)
                        .padding(.bottom, AppSpacing.sm)
                    
                    Text("Reset Password")
                        .appFont(AppFonts.title2)
                        .foregroundColor(AppColors.textPrimary)
                    
                    Text("Enter your email address and we'll send you a link to reset your password.")
                        .appFont(AppFonts.body)
                        .foregroundColor(AppColors.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, AppSpacing.lg)
                }
                .padding(.top, AppSpacing.xxl)
                
                if isSuccess {
                    VStack(spacing: AppSpacing.lg) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 64))
                            .foregroundColor(AppColors.success)
                        
                        Text("Reset Link Sent!")
                            .font(AppFonts.headline)
                            .foregroundColor(AppColors.textPrimary)
                        
                        PrimaryButton(title: "Back to Login", fullWidth: true) {
                            appState.navigationPath.removeLast()
                        }
                    }
                    .transition(.opacity)
                } else {
                    // Form
                    VStack(spacing: AppSpacing.lg) {
                        AuthTextField(
                            icon: "envelope.fill",
                            placeholder: "Email Address",
                            text: $viewModel.resetEmail,
                            keyboardType: .emailAddress
                        )
                        
                        PrimaryButton(
                            title: "Send Reset Link",
                            isLoading: viewModel.isLoading,
                            isDisabled: !viewModel.isResetFormValid
                        ) {
                            Task {
                                if await viewModel.resetPassword() {
                                    withAnimation {
                                        isSuccess = true
                                    }
                                }
                            }
                        }
                    }
                    .transition(.opacity)
                }
                
                Spacer()
            }
            .padding(.horizontal, AppSpacing.xl)
        }
        .navigationBarBackButtonHidden(true)
        // Custom Back Button
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                IconButton(icon: AppIcon.back, size: 36, iconSize: 18, style: .ghost) {
                    appState.navigationPath.removeLast()
                }
            }
        }
        .alert(isPresented: $viewModel.showError) {
            Alert(
                title: Text("Error"),
                message: Text(viewModel.errorMessage ?? "Unknown error"),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

#Preview {
    NavigationStack {
        ForgotPasswordView()
            .environmentObject(AppState())
    }
}
