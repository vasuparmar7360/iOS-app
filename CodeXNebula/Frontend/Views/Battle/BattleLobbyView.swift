//
//  BattleLobbyView.swift
//  CodeXNebula
//

import SwiftUI

struct BattleLobbyView: View {
    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()
            VStack {
                Text("Battle Lobby")
                    .appFont(AppFonts.title)
                    .foregroundColor(AppColors.neonCyan)
                Text("Preparing for battle...")
                    .appFont(AppFonts.body)
                    .foregroundColor(AppColors.textSecondary)
            }
        }
    }
}
