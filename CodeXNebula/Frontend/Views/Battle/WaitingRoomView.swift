//
//  WaitingRoomView.swift
//  CodeXNebula
//

import SwiftUI

struct WaitingRoomView: View {
    @ObservedObject var viewModel: BattleViewModel
    @Environment(\.dismiss) var dismiss
    @State private var rotation: Double = 0
    @State private var countdown: Int = 3 // 3 seconds to simulate opponent accepting
    @State private var navigateToArena: Bool = false
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()
            
            if let friend = viewModel.selectedFriend, let lang = viewModel.selectedLanguage, let chap = viewModel.selectedChapter {
                NavigationLink(
                    destination: BattleArenaView(
                        opponent: friend,
                        language: lang,
                        chapter: chap,
                        difficulty: viewModel.selectedDifficulty,
                        durationMinutes: viewModel.selectedDuration
                    ),
                    isActive: $navigateToArena
                ) {
                    EmptyView()
                }
            }
            
            VStack(spacing: AppSpacing.xl) {
                Spacer()
                
                // Animated Loader
                ZStack {
                    Circle()
                        .stroke(AppColors.borderSubtle, lineWidth: 4)
                        .frame(width: 120, height: 120)
                    
                    Circle()
                        .trim(from: 0, to: 0.25)
                        .stroke(AppColors.neonCyan, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                        .frame(width: 120, height: 120)
                        .rotationEffect(.degrees(rotation))
                        .onAppear {
                            withAnimation(.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                                rotation = 360
                            }
                        }
                    
                    Image(systemName: "bolt.shield.fill")
                        .font(.system(size: 40))
                        .foregroundColor(AppColors.neonCyan)
                }
                
                VStack(spacing: AppSpacing.sm) {
                    Text("Waiting for opponent...")
                        .appFont(AppFonts.title2)
                        .foregroundColor(AppColors.textPrimary)
                    
                    if let friend = viewModel.selectedFriend {
                        Text("Sent to \(friend.username)")
                            .font(AppFonts.body)
                            .foregroundColor(AppColors.textSecondary)
                    }
                }
                
                GlassCard(padding: AppSpacing.md) {
                    VStack(spacing: AppSpacing.sm) {
                        HStack {
                            Text("Language")
                                .font(AppFonts.caption)
                                .foregroundColor(AppColors.textSecondary)
                            Spacer()
                            Text(viewModel.selectedLanguage?.name ?? "Unknown")
                                .font(AppFonts.headline)
                                .foregroundColor(AppColors.textPrimary)
                        }
                        
                        Divider().background(AppColors.borderSubtle)
                        
                        HStack {
                            Text("Duration")
                                .font(AppFonts.caption)
                                .foregroundColor(AppColors.textSecondary)
                            Spacer()
                            Text("\(viewModel.selectedDuration) Minutes")
                                .font(AppFonts.headline)
                                .foregroundColor(AppColors.textPrimary)
                        }
                        
                        Divider().background(AppColors.borderSubtle)
                        
                        HStack {
                            Text("Expires In")
                                .font(AppFonts.caption)
                                .foregroundColor(AppColors.textSecondary)
                            Spacer()
                            Text(String(format: "%02d:%02d", countdown / 60, countdown % 60))
                                .font(AppFonts.code)
                                .foregroundColor(AppColors.warning)
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding(.horizontal, AppSpacing.xl)
                
                Spacer()
                
                DangerButton(title: "Cancel Battle", icon: "xmark.circle.fill") {
                    Task {
                        await viewModel.cancelInvitation()
                        dismiss()
                    }
                }
                .padding(.horizontal, AppSpacing.xl)
                .padding(.bottom, AppSpacing.xl)
            }
        }
        .navigationBarHidden(true)
        .onReceive(timer) { _ in
            if countdown > 0 {
                countdown -= 1
            } else {
                timer.upstream.connect().cancel()
                navigateToArena = true
            }
        }
    }
}
