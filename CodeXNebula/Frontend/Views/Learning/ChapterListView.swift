//
//  ChapterListView.swift
//  CodeXNebula
//
//  Screen for selecting a chapter within a language.
//

import SwiftUI

struct ChapterListView: View {
    let language: Language
    @ObservedObject var viewModel: LearningViewModel
    
    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: AppSpacing.md) {
                    
                    // Header
                    VStack(alignment: .leading, spacing: AppSpacing.sm) {
                        Text("\(language.name) Chapters")
                            .appFont(AppFonts.title2)
                            .foregroundColor(AppColors.textPrimary)
                        
                        Text("Master the fundamentals of \(language.name).")
                            .appFont(AppFonts.body)
                            .foregroundColor(AppColors.textSecondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, AppSpacing.xl)
                    .padding(.top, AppSpacing.lg)
                    .padding(.bottom, AppSpacing.sm)
                    
                    if viewModel.isLoadingChapters {
                        ProgressView()
                            .tint(AppColors.neonCyan)
                            .padding(.top, 50)
                    } else {
                        ForEach(viewModel.chapters) { chapter in
                            NavigationLink(value: chapter) {
                                ChapterRow(chapter: chapter)
                            }
                        }
                        .padding(.horizontal, AppSpacing.xl)
                    }
                    
                    Spacer(minLength: 40)
                }
            }
        }
        .navigationTitle(language.name)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.selectLanguage(language)
        }
        .navigationDestination(for: Chapter.self) { chapter in
            ProblemListView(chapter: chapter, viewModel: viewModel)
        }
    }
}

// MARK: - ChapterRow

struct ChapterRow: View {
    let chapter: Chapter
    
    var body: some View {
        GlassCard {
            HStack(spacing: AppSpacing.md) {
                // Chapter Number Circle
                ZStack {
                    Circle()
                        .fill(AppColors.neonPurple.opacity(0.1))
                        .frame(width: 40, height: 40)
                    
                    Text("\(chapter.sortOrder)")
                        .font(AppFonts.headline)
                        .foregroundColor(AppColors.neonPurple)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(chapter.title)
                        .appFont(AppFonts.headline)
                        .foregroundColor(AppColors.textPrimary)
                    
                    Text(chapter.description)
                        .font(AppFonts.caption)
                        .foregroundColor(AppColors.textSecondary)
                        .lineLimit(2)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(AppColors.textTertiary)
            }
            .padding(AppSpacing.md)
        }
    }
}
