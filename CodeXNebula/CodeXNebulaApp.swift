//
//  CodeXNebulaApp.swift
//  CodeXNebula
//
//  Entry point for the CodeX Nebula gamified programming learning platform.
//

import SwiftUI

@main
struct CodeXNebulaApp: App {

    // MARK: - State
    @StateObject private var appState = AppState()

    // MARK: - Body
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
                .preferredColorScheme(.dark)
        }
    }
}
