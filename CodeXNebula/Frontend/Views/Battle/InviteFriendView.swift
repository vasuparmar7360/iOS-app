//
//  InviteFriendView.swift
//  CodeXNebula
//

import SwiftUI

struct InviteFriendView: View {
    @ObservedObject var viewModel: BattleViewModel
    let friend: Friend
    
    let durations = [5, 10, 15]
    
    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: AppSpacing.lg) {
                    
                    // Selected Friend
                    GlassCard(padding: AppSpacing.md) {
                        VStack(spacing: AppSpacing.sm) {
                            Text("Challenging")
                                .font(AppFonts.caption)
                                .foregroundColor(AppColors.textSecondary)
                            Text(friend.username)
                                .appFont(AppFonts.title2)
                                .foregroundColor(AppColors.neonCyan)
                        }
                        .frame(maxWidth: .infinity)
                    }
                    
                    // Language Selection
                    VStack(alignment: .leading, spacing: AppSpacing.sm) {
                        Text("Programming Language")
                            .appFont(AppFonts.headline)
                            .foregroundColor(AppColors.textPrimary)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: AppSpacing.sm) {
                                ForEach(viewModel.availableLanguages) { lang in
                                    SelectionButton(title: lang.name, isSelected: viewModel.selectedLanguage?.id == lang.id, color: AppColors.neonCyan) {
                                        Task { await viewModel.loadChapters(for: lang) }
                                    }
                                }
                            }
                        }
                    }
                    
                    // Chapter Selection
                    if !viewModel.availableChapters.isEmpty {
                        VStack(alignment: .leading, spacing: AppSpacing.sm) {
                            Text("Chapter")
                                .appFont(AppFonts.headline)
                                .foregroundColor(AppColors.textPrimary)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: AppSpacing.sm) {
                                    ForEach(viewModel.availableChapters) { chapter in
                                        SelectionButton(title: chapter.title, isSelected: viewModel.selectedChapter?.id == chapter.id, color: AppColors.neonCyan) {
                                            viewModel.selectedChapter = chapter
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                    // Difficulty Selection
                    VStack(alignment: .leading, spacing: AppSpacing.sm) {
                        Text("Difficulty")
                            .appFont(AppFonts.headline)
                            .foregroundColor(AppColors.textPrimary)
                        
                        HStack(spacing: AppSpacing.md) {
                            ForEach(ProblemDifficulty.allCases, id: \.self) { diff in
                                SelectionButton(title: diff.rawValue, isSelected: viewModel.selectedDifficulty == diff, color: diff.color) {
                                    viewModel.selectedDifficulty = diff
                                }
                            }
                        }
                    }
                    
                    // Duration Selection
                    VStack(alignment: .leading, spacing: AppSpacing.sm) {
                        Text("Battle Duration")
                            .appFont(AppFonts.headline)
                            .foregroundColor(AppColors.textPrimary)
                        
                        HStack(spacing: AppSpacing.md) {
                            ForEach(durations, id: \.self) { duration in
                                SelectionButton(title: "\(duration)m", isSelected: viewModel.selectedDuration == duration, color: AppColors.neonPurple) {
                                    viewModel.selectedDuration = duration
                                }
                            }
                        }
                    }
                    
                    Spacer(minLength: 40)
                    
                    NavigationLink(destination: WaitingRoomView(viewModel: viewModel), isActive: Binding(
                        get: { viewModel.activeInvitation != nil },
                        set: { if !$0 { Task { await viewModel.cancelInvitation() } } }
                    )) {
                        EmptyView()
                    }
                    
                    PrimaryButton(title: "Send Invitation", icon: "paperplane.fill", isLoading: viewModel.isSendingInvitation, isDisabled: !friend.isOnline || viewModel.selectedLanguage == nil || viewModel.selectedChapter == nil) {
                        viewModel.selectedFriend = friend
                        Task {
                            await viewModel.sendInvitation(to: friend)
                        }
                    }
                }
                .padding(AppSpacing.md)
            }
        }
        .navigationTitle("Battle Setup")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct SelectionButton: View {
    let title: String
    let isSelected: Bool
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(AppFonts.buttonPrimary)
                .foregroundColor(isSelected ? AppColors.background : AppColors.textPrimary)
                .padding(.horizontal, 16)
                .padding(.vertical, AppSpacing.sm)
                .background(isSelected ? color : AppColors.cardBackground)
                .cornerRadius(AppRadius.card)
                .overlay(
                    RoundedRectangle(cornerRadius: AppRadius.card)
                        .stroke(isSelected ? color : AppColors.borderSubtle, lineWidth: 1)
                )
        }
        .buttonStyle(.plain)
    }
}
