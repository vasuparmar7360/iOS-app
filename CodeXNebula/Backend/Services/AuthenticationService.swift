//
//  AuthenticationService.swift
//  CodeXNebula
//
//  Mock backend service for handling authentication.
//  Prepared for future Firebase/Apple/Google integration.
//

import Foundation

enum AuthError: Error, LocalizedError {
    case duplicateEmail
    case duplicateUsername
    case userNotFound
    case invalidPassword
    case networkError
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .duplicateEmail: return "An account with this email already exists."
        case .duplicateUsername: return "Username is already taken."
        case .userNotFound: return "No account found with this email."
        case .invalidPassword: return "Incorrect password."
        case .networkError: return "Network connection error. Please try again."
        case .unknown: return "An unknown error occurred."
        }
    }
}

class AuthenticationService {
    
    static let shared = AuthenticationService()
    private let storage = UserStorageService.shared
    
    private init() {}
    
    /// Simulates account creation
    func signUp(user: User) async throws -> User {
        // Simulate network delay
        try await Task.sleep(nanoseconds: 1_500_000_000)
        
        let allUsers = storage.getAllUsers().values
        
        // Validate duplicates
        if allUsers.contains(where: { $0.email.lowercased() == user.email.lowercased() }) {
            throw AuthError.duplicateEmail
        }
        
        if allUsers.contains(where: { $0.username.lowercased() == user.username.lowercased() }) {
            throw AuthError.duplicateUsername
        }
        
        // Save to mock database
        storage.saveUser(user)
        return user
    }
    
    /// Simulates user login
    func login(email: String, passwordHash: String) async throws -> User {
        // Simulate network delay
        try await Task.sleep(nanoseconds: 1_200_000_000)
        
        let allUsers = storage.getAllUsers().values
        
        guard let user = allUsers.first(where: { $0.email.lowercased() == email.lowercased() }) else {
            throw AuthError.userNotFound
        }
        
        guard user.passwordHash == passwordHash else {
            throw AuthError.invalidPassword
        }
        
        return user
    }
    
    /// Simulates password reset
    func resetPassword(email: String) async throws {
        // Simulate network delay
        try await Task.sleep(nanoseconds: 1_000_000_000)
        
        let allUsers = storage.getAllUsers().values
        
        guard allUsers.contains(where: { $0.email.lowercased() == email.lowercased() }) else {
            throw AuthError.userNotFound
        }
        
        // In a real app, this would send an email.
    }
    
    /// Simulates social login (Apple/Google) and account linking
    func socialLogin(email: String, fullName: String) async throws -> User {
        try await Task.sleep(nanoseconds: 1_200_000_000)
        
        let allUsers = storage.getAllUsers().values
        
        if let existingUser = allUsers.first(where: { $0.email.lowercased() == email.lowercased() }) {
            // Account linked by email
            return existingUser
        }
        
        // Create new user for social login
        let baseUsername = fullName.lowercased().replacingOccurrences(of: " ", with: "")
        let randomSuffix = String(Int.random(in: 1000...9999))
        
        let newUser = User(
            fullName: fullName,
            username: baseUsername.isEmpty ? "user\(randomSuffix)" : baseUsername + randomSuffix,
            email: email,
            passwordHash: "SOCIAL_AUTH_NO_PASSWORD"
        )
        
        storage.saveUser(newUser)
        return newUser
    }
}
//
//  AppleSignInManager.swift
//  CodeXNebula
//
//  Native Apple Sign In Manager using AuthenticationServices.
//

import Foundation
import AuthenticationServices

class AppleSignInManager: NSObject, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    private var completion: ((Result<(email: String, fullName: String), Error>) -> Void)?
    
    func signIn(completion: @escaping (Result<(email: String, fullName: String), Error>) -> Void) {
        self.completion = completion
        
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
    
    // MARK: - ASAuthorizationControllerDelegate
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            
            let email = appleIDCredential.email ?? "appleuser_\(appleIDCredential.user.prefix(6))@privaterelay.appleid.com"
            let givenName = appleIDCredential.fullName?.givenName ?? "Apple"
            let familyName = appleIDCredential.fullName?.familyName ?? "User"
            let fullName = "\(givenName) \(familyName)".trimmingCharacters(in: .whitespaces)
            
            completion?(.success((email: email, fullName: fullName)))
        } else {
            completion?(.failure(NSError(domain: "AppleSignIn", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid credential type."])))
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        completion?(.failure(error))
    }
    
    // MARK: - ASAuthorizationControllerPresentationContextProviding
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        // Needs a window for presentation. This returns the first active window.
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first { $0.isKeyWindow }
        return window ?? UIWindow()
    }
}
