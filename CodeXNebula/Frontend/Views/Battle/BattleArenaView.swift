//
//  BattleArenaView.swift
//  CodeXNebula
//

import SwiftUI

struct BattleArenaView: View {
    @StateObject private var viewModel: BattleArenaViewModel
    @Environment(\.dismiss) var dismiss
    
    init(opponent: Friend, language: Language, chapter: Chapter, difficulty: ProblemDifficulty, durationMinutes: Int) {
        _viewModel = StateObject(wrappedValue: BattleArenaViewModel(opponent: opponent, language: language, chapter: chapter, difficulty: difficulty, durationMinutes: durationMinutes))
    }
    
    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()
            
            if viewModel.state == .loading {
                VStack(spacing: AppSpacing.md) {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: AppColors.neonCyan))
                        .scaleEffect(1.5)
                    Text("Connecting to Arena...")
                        .font(AppFonts.body)
                        .foregroundColor(AppColors.textSecondary)
                }
            } else if viewModel.state == .finished {
                AIJudgeResultView(player1Code: viewModel.code, player2Code: viewModel.opponentCode)
            } else if viewModel.state == .waitingForOpponent {
                VStack(spacing: AppSpacing.xl) {
                    Text("Submission Complete")
                        .appFont(AppFonts.title2)
                        .foregroundColor(AppColors.success)
                    
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: AppColors.neonCyan))
                        .scaleEffect(1.5)
                    
                    Text(viewModel.opponentStatus)
                        .font(AppFonts.body)
                        .foregroundColor(AppColors.textSecondary)
                        .padding(.top, AppSpacing.sm)
                }
            } else {
                VStack(spacing: 0) {
                    // Top Bar
                    HStack {
                        VStack(alignment: .leading) {
                            Text(viewModel.playerUsername)
                                .font(AppFonts.headline)
                                .foregroundColor(AppColors.textPrimary)
                            Text("You")
                                .font(AppFonts.caption)
                                .foregroundColor(AppColors.textSecondary)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .center) {
                            Text("VS")
                                .font(.system(size: 16, weight: .black, design: .monospaced))
                                .foregroundColor(AppColors.neonPurple)
                            Text("\(viewModel.language.name) • \(viewModel.difficulty.rawValue)")
                                .font(AppFonts.caption)
                                .foregroundColor(AppColors.textSecondary)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing) {
                            Text(viewModel.opponentUsername)
                                .font(AppFonts.headline)
                                .foregroundColor(AppColors.neonCyan)
                            Text("Opponent")
                                .font(AppFonts.caption)
                                .foregroundColor(AppColors.textSecondary)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    .background(AppColors.backgroundSecondary)
                    
                    // Timer
                    HStack {
                        Spacer()
                        BattleTimerView(timer: viewModel.timer)
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    
                    // Main Split View
                    GeometryReader { geo in
                        VStack(spacing: 0) {
                            if let problem = viewModel.problem {
                                BattleProblemView(problem: problem)
                                    .frame(height: geo.size.height * 0.35)
                            }
                            
                            Divider().background(AppColors.borderSubtle)
                            
                            BattleEditorView(viewModel: viewModel)
                                .frame(height: geo.size.height * 0.65)
                        }
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            Task {
                await viewModel.startBattle()
            }
        }
        .onDisappear {
            viewModel.exitBattle()
        }
    }
}
