//
//  LoginView.swift
//  CodeXNebula
//
//  The premium futuristic login screen.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject private var appState: AppState
    @StateObject private var viewModel = AuthenticationViewModel()
    
    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: AppSpacing.xxl) {
                    
                    // Logo Header
                    VStack(spacing: AppSpacing.sm) {
                        Image(systemName: AppIcon.code)
                            .font(.system(size: 48, weight: .bold))
                            .foregroundColor(AppColors.neonCyan)
                            .shadow(color: AppColors.neonCyan.opacity(0.5), radius: 10)
                            .padding(.bottom, AppSpacing.sm)
                        
                        Text("Welcome Back")
                            .appFont(AppFonts.title2)
                            .foregroundColor(AppColors.textPrimary)
                        
                        Text("Login to continue your journey.")
                            .appFont(AppFonts.body)
                            .foregroundColor(AppColors.textSecondary)
                    }
                    .padding(.top, AppSpacing.xxl)
                    
                    // Forms
                    VStack(spacing: AppSpacing.lg) {
                        AuthTextField(
                            icon: "envelope.fill",
                            placeholder: "Email Address",
                            text: $viewModel.loginEmail,
                            keyboardType: .emailAddress
                        )
                        
                        AuthTextField(
                            icon: "lock.fill",
                            placeholder: "Password",
                            text: $viewModel.loginPassword,
                            isSecure: true
                        )
                        
                        // Forgot Password Link
                        HStack {
                            Spacer()
                            Button(action: {
                                appState.navigate(to: .forgotPassword)
                            }) {
                                Text("Forgot Password?")
                                    .font(AppFonts.footnote)
                                    .foregroundColor(AppColors.neonCyan)
                            }
                        }
                    }
                    
                    // Primary Action
                    PrimaryButton(
                        title: "Login",
                        isLoading: viewModel.isLoading,
                        isDisabled: !viewModel.isLoginFormValid
                    ) {
                        Task {
                            if await viewModel.login() {
                                // Set global user state
                                appState.currentUser = viewModel.currentUser
                                
                            }
                        }
                    }
                    
                    // Divider
                    HStack(spacing: AppSpacing.md) {
                        NeonDivider(color: AppColors.textTertiary)
                        Text("OR")
                            .font(AppFonts.caption2)
                            .foregroundColor(AppColors.textTertiary)
                        NeonDivider(color: AppColors.textTertiary)
                    }
                    
                    // Social Login
                    VStack(spacing: AppSpacing.md) {
                        SocialLoginButton(platform: .apple) {
                            viewModel.loginWithApple { user in
                                appState.currentUser = user
                            }
                        }
                        SocialLoginButton(platform: .google) {
                            Task {
                                if await viewModel.simulateGoogleLogin() {
                                    appState.currentUser = viewModel.currentUser
                                }
                            }
                        }
                    }
                    
                    // Sign Up Link
                    HStack(spacing: 4) {
                        Text("Don't have an account?")
                            .font(AppFonts.callout)
                            .foregroundColor(AppColors.textSecondary)
                        Button(action: {
                            appState.navigate(to: .signUp)
                        }) {
                            Text("Sign Up")
                                .font(AppFonts.callout)
                                .foregroundColor(AppColors.neonCyan)
                        }
                    }
                    .padding(.top, AppSpacing.lg)
                    .padding(.bottom, AppSpacing.xxl)
                    
                }
                .padding(.horizontal, AppSpacing.xl)
            }
        }
        .navigationBarBackButtonHidden(true)
        .alert(isPresented: $viewModel.showError) {
            Alert(
                title: Text("Login Failed"),
                message: Text(viewModel.errorMessage ?? "Unknown error"),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(AppState())
}
