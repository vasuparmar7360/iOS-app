//
//  CodeComparisonView.swift
//  CodeXNebula
//

import SwiftUI

struct CodeComparisonView: View {
    let player1Code: String
    let player2Code: String
    
    @State private var showingOpponent = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            HStack {
                Text("Code Review")
                    .appFont(AppFonts.title2)
                    .foregroundColor(AppColors.textPrimary)
                Spacer()
                
                Picker("Code View", selection: $showingOpponent) {
                    Text("Your Code").tag(false)
                    Text("Opponent").tag(true)
                }
                .pickerStyle(SegmentedPickerStyle())
                .frame(width: 150)
            }
            .padding(.horizontal)
            
            GlassCard(padding: 0) {
                ScrollView(.horizontal) {
                    Text(showingOpponent ? player2Code : player1Code)
                        .font(AppFonts.code)
                        .foregroundColor(AppColors.textPrimary)
                        .padding()
                }
                .background(AppColors.backgroundSecondary)
                .cornerRadius(AppRadius.card)
            }
            .padding(.horizontal)
        }
    }
}
