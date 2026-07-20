//
//  SignUpView.swift
//  CodeXNebula
//
//  User registration screen.
//

import SwiftUI

struct SignUpView: View {
    @EnvironmentObject private var appState: AppState
    @StateObject private var viewModel = AuthenticationViewModel()
    
    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: AppSpacing.xl) {
                    
                    // Header
                    VStack(spacing: AppSpacing.sm) {
                        Text("Create Account")
                            .appFont(AppFonts.title2)
                            .foregroundColor(AppColors.textPrimary)
                        
                        Text("Join the CodeX Nebula")
                            .appFont(AppFonts.body)
                            .foregroundColor(AppColors.textSecondary)
                    }
                    .padding(.top, AppSpacing.xl)
                    
                    // Forms
                    VStack(spacing: AppSpacing.md) {
                        AuthTextField(
                            icon: "person.fill",
                            placeholder: "Full Name",
                            text: $viewModel.signupFullName,
                            autoCapitalization: .words
                        )
                        
                        AuthTextField(
                            icon: "at",
                            placeholder: "Username",
                            text: $viewModel.signupUsername
                        )
                        
                        AuthTextField(
                            icon: "envelope.fill",
                            placeholder: "Email Address",
                            text: $viewModel.signupEmail,
                            keyboardType: .emailAddress
                        )
                        
                        AuthTextField(
                            icon: "lock.fill",
                            placeholder: "Create Password",
                            text: $viewModel.signupPassword,
                            isSecure: true
                        )
                        
                        AuthTextField(
                            icon: "lock.fill",
                            placeholder: "Confirm Password",
                            text: $viewModel.signupConfirmPassword,
                            isSecure: true
                        )
                    }
                    .padding(.top, AppSpacing.sm)
                    
                    // Primary Action
                    PrimaryButton(
                        title: "Create Account",
                        isLoading: viewModel.isLoading,
                        isDisabled: !viewModel.isSignupFormValid
                    ) {
                        Task {
                            if await viewModel.signUp() {
                                // Set global user state
                                appState.currentUser = viewModel.currentUser
                                
                            }
                        }
                    }
                    .padding(.top, AppSpacing.md)
                    
                    // Divider
                    HStack(spacing: AppSpacing.md) {
                        NeonDivider(color: AppColors.textTertiary)
                        Text("OR")
                            .font(AppFonts.caption2)
                            .foregroundColor(AppColors.textTertiary)
                        NeonDivider(color: AppColors.textTertiary)
                    }
                    .padding(.vertical, AppSpacing.sm)
                    
                    // Social Sign Up
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
                    
                    // Login Link
                    HStack(spacing: 4) {
                        Text("Already have an account?")
                            .font(AppFonts.callout)
                            .foregroundColor(AppColors.textSecondary)
                        Button(action: {
                            appState.navigationPath.removeLast()
                        }) {
                            Text("Login")
                                .font(AppFonts.callout)
                                .foregroundColor(AppColors.neonCyan)
                        }
                    }
                    .padding(.top, AppSpacing.xl)
                    .padding(.bottom, AppSpacing.xxl)
                    
                }
                .padding(.horizontal, AppSpacing.xl)
            }
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
                title: Text("Sign Up Failed"),
                message: Text(viewModel.errorMessage ?? "Unknown error"),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

#Preview {
    NavigationStack {
        SignUpView()
            .environmentObject(AppState())
    }
}
