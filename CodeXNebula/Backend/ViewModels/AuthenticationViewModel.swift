//
//  AuthenticationViewModel.swift
//  CodeXNebula
//
//  Manages the state and logic for login, signup, and password reset flows.
//

import SwiftUI
import Combine
import CryptoKit
import AuthenticationServices

@MainActor
class AuthenticationViewModel: ObservableObject {
    
    // Login Form State
    @Published var loginEmail = ""
    @Published var loginPassword = ""
    
    // Signup Form State
    @Published var signupFullName = ""
    @Published var signupUsername = ""
    @Published var signupEmail = ""
    @Published var signupPassword = ""
    @Published var signupConfirmPassword = ""
    
    // Reset Password State
    @Published var resetEmail = ""
    
    // UI State
    @Published var isLoading = false
    @Published var errorMessage: String? = nil
    @Published var showError = false
    
    // Session State
    @Published var currentUser: User? = nil
    
    private let authService = AuthenticationService.shared
    private let appleSignInManager = AppleSignInManager()
    
    // MARK: - Validation
    
    var isLoginFormValid: Bool {
        !loginEmail.trimmingCharacters(in: .whitespaces).isEmpty &&
        !loginPassword.isEmpty
    }
    
    var isSignupFormValid: Bool {
        !signupFullName.trimmingCharacters(in: .whitespaces).isEmpty &&
        !signupUsername.trimmingCharacters(in: .whitespaces).isEmpty &&
        !signupEmail.trimmingCharacters(in: .whitespaces).isEmpty &&
        !signupPassword.isEmpty &&
        signupPassword == signupConfirmPassword
    }
    
    var isResetFormValid: Bool {
        !resetEmail.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    // MARK: - Actions
    
    func login() async -> Bool {
        guard isLoginFormValid else { return false }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let hashed = hashPassword(loginPassword)
            let user = try await authService.login(email: loginEmail, passwordHash: hashed)
            self.currentUser = user
            isLoading = false
            return true
        } catch {
            self.errorMessage = error.localizedDescription
            self.showError = true
            isLoading = false
            return false
        }
    }
    
    func signUp() async -> Bool {
        guard isSignupFormValid else {
            if signupPassword != signupConfirmPassword {
                errorMessage = "Passwords do not match."
                showError = true
            }
            return false
        }
        
        isLoading = true
        errorMessage = nil
        
        let newUser = User(
            fullName: signupFullName,
            username: signupUsername,
            email: signupEmail,
            passwordHash: hashPassword(signupPassword)
        )
        
        do {
            let user = try await authService.signUp(user: newUser)
            self.currentUser = user
            isLoading = false
            return true
        } catch {
            self.errorMessage = error.localizedDescription
            self.showError = true
            isLoading = false
            return false
        }
    }
    
    func resetPassword() async -> Bool {
        guard isResetFormValid else { return false }
        
        isLoading = true
        errorMessage = nil
        
        do {
            try await authService.resetPassword(email: resetEmail)
            isLoading = false
            return true
        } catch {
            self.errorMessage = error.localizedDescription
            self.showError = true
            isLoading = false
            return false
        }
    }
    
    func loginWithSocial(email: String, fullName: String) async -> Bool {
        isLoading = true
        errorMessage = nil
        
        do {
            let user = try await authService.socialLogin(email: email, fullName: fullName)
            self.currentUser = user
            isLoading = false
            return true
        } catch {
            self.errorMessage = error.localizedDescription
            self.showError = true
            isLoading = false
            return false
        }
    }
    
    func simulateGoogleLogin() async -> Bool {
        // Mocking Google Sign-In SDK Flow
        return await loginWithSocial(email: "hacker@gmail.com", fullName: "Google Hacker")
    }
    
    func loginWithApple(onSuccess: @escaping (User) -> Void) {
        appleSignInManager.signIn { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let data):
                    Task {
                        _ = await self.loginWithSocial(email: data.email, fullName: data.fullName)
                        if let user = self.currentUser {
                            onSuccess(user)
                        }
                    }
                case .failure(let error):
                    let nsError = error as NSError
                    if nsError.code == 1001 || nsError.code == ASAuthorizationError.canceled.rawValue {
                        // user cancelled
                        return
                    }
                    self.errorMessage = "Apple Sign In failed: \(error.localizedDescription)"
                    self.showError = true
                }
            }
        }
    }
    
    func clearForm() {
        loginEmail = ""
        loginPassword = ""
        signupFullName = ""
        signupUsername = ""
        signupEmail = ""
        signupPassword = ""
        signupConfirmPassword = ""
        resetEmail = ""
        errorMessage = nil
        showError = false
    }
    
    // MARK: - Security
    
    private func hashPassword(_ password: String) -> String {
        let inputData = Data(password.utf8)
        let hashed = SHA256.hash(data: inputData)
        return hashed.compactMap { String(format: "%02x", $0) }.joined()
    }
}
