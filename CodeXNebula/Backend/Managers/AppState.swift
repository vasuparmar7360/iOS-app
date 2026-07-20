//
//  AppState.swift
//  CodeXNebula
//
//  Global application state observed throughout the view hierarchy.
//  Injected as an EnvironmentObject from CodeXNebulaApp.
//

import SwiftUI
import Combine

@MainActor
final class AppState: ObservableObject {

    // MARK: - Navigation
    @Published var navigationPath = NavigationPath()
    @Published var hasCompletedSplash: Bool = false

    // MARK: - Session
    @Published var isAuthenticated: Bool = false
    @Published var currentUser: User? = nil {
        didSet {
            if let user = currentUser {
                UserStorageService.shared.saveCurrentUserSession(user)
                isAuthenticated = true
            } else {
                UserStorageService.shared.clearCurrentUserSession()
                isAuthenticated = false
            }
        }
    }

    // MARK: - UI State
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil

    // MARK: - Init
    init() {
        // Attempt auto-login
        if let savedUser = UserStorageService.shared.getCurrentUserSession() {
            self.currentUser = savedUser
        }
    }

    // MARK: - Navigation Helpers

    /// Push a new route onto the stack.
    func navigate(to route: AppRoute) {
        navigationPath.append(route)
    }

    /// Pop back one level.
    func goBack() {
        if !navigationPath.isEmpty {
            navigationPath.removeLast()
        }
    }

    /// Return to root.
    func popToRoot() {
        navigationPath = NavigationPath()
    }
    
    /// Clear all previous routes and set a new root route.
    func clearAndNavigate(to route: AppRoute) {
        navigationPath = NavigationPath([route])
    }
}
