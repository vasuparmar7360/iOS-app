//
//  AppRouter.swift
//  CodeXNebula
//
//  Defines all navigation routes for the application.
//  Add new routes here as screens are implemented.
//

import SwiftUI

/// All navigable destinations in the app.
enum AppRoute: Hashable {
    // Auth
    case login
    case signUp
    case forgotPassword
    
    // Main App
    case home
    
    // Placeholder
    case placeholder
}

extension AppRoute {
    /// Returns the SwiftUI view associated with this route.
    @ViewBuilder
    var destination: some View {
        switch self {
        case .login:
            LoginView()
        case .signUp:
            SignUpView()
        case .forgotPassword:
            ForgotPasswordView()
        case .home:
            MainTabView()
        case .placeholder:
            Text("Coming Soon")
                .foregroundColor(AppColors.textSecondary)
        }
    }
}

enum CodingDestination: Hashable {
    case detail(problem: CodingProblem, language: Language)
    case editor(problem: CodingProblem, language: Language)
}
