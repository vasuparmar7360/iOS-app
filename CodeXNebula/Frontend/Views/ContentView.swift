//
//  ContentView.swift
//  CodeXNebula
//
//  Root view that hosts the NavigationStack and delegates
//  to the appropriate screen based on AppState.
//

import SwiftUI

struct ContentView: View {

    @EnvironmentObject private var appState: AppState

    var body: some View {
        if !appState.hasCompletedSplash {
            SplashView()
        } else if appState.isAuthenticated {
            MainTabView()
                .tint(AppColors.neonCyan)
        } else {
            NavigationStack(path: $appState.navigationPath) {
                LoginView()
                    .navigationDestination(for: AppRoute.self) { route in
                        route.destination
                    }
            }
            .tint(AppColors.neonCyan)
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AppState())
        .preferredColorScheme(.dark)
}
