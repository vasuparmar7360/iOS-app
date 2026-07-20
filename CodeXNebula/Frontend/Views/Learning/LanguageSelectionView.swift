//
//  LanguageSelectionView.swift
//  CodeXNebula
//
//  Screen for selecting a programming language.
//

import SwiftUI

struct LanguageSelectionView: View {
    @StateObject private var viewModel = LearningViewModel()
    
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: AppSpacing.xl) {
                    
                    // Header
                    VStack(alignment: .leading, spacing: AppSpacing.sm) {
                        Text("Learning Journey")
                            .appFont(AppFonts.title2)
                            .foregroundColor(AppColors.textPrimary)
                        
                        Text("Select a language to begin your training.")
                            .appFont(AppFonts.body)
                            .foregroundColor(AppColors.textSecondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, AppSpacing.xl)
                    .padding(.top, AppSpacing.lg)
                    
                    if viewModel.isLoadingLanguages {
                        ProgressView()
                            .tint(AppColors.neonCyan)
                            .padding(.top, 50)
                    } else {
                        LazyVGrid(columns: columns, spacing: AppSpacing.md) {
                            ForEach(viewModel.languages) { language in
                                NavigationLink(value: language) {
                                    LanguageCard(language: language)
                                }
                            }
                        }
                        .padding(.horizontal, AppSpacing.xl)
                    }
                    
                    Spacer(minLength: 40)
                }
            }
        }
        .navigationTitle("Languages")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(AppColors.background, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .task {
            if viewModel.languages.isEmpty {
                await viewModel.loadLanguages()
            }
        }
        .navigationDestination(for: Language.self) { language in
            ChapterListView(language: language, viewModel: viewModel)
        }
        .navigationDestination(for: CodingDestination.self) { destination in
            switch destination {
            case .detail(let problem, let language):
                ProblemDetailView(problem: problem, language: language)
            case .editor(let problem, let language):
                CodeEditorView(viewModel: CodingViewModel(problem: problem, language: language))
            }
        }
    }
}

// MARK: - LanguageCard

struct LanguageCard: View {
    let language: Language
    
    var body: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: AppSpacing.sm) {
                HStack {
                    Image(systemName: language.iconName)
                        .font(.system(size: 24))
                        .foregroundColor(AppColors.neonCyan)
                    Spacer()
                    Text("\(Int(language.progress * 100))%")
                        .font(AppFonts.caption)
                        .foregroundColor(AppColors.neonCyan)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(AppColors.neonCyan.opacity(0.1))
                        .cornerRadius(8)
                }
                
                Text(language.name)
                    .appFont(AppFonts.headline)
                    .foregroundColor(AppColors.textPrimary)
                    .padding(.top, AppSpacing.xs)
                
                    Text("\(language.completedProblems) / \(language.totalProblems) Problems")
                        .font(AppFonts.caption)
                        .foregroundColor(AppColors.textSecondary)
                
                // Progress Bar
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(AppColors.textTertiary.opacity(0.3))
                            .frame(height: 4)
                        
                        Capsule()
                            .fill(AppColors.neonCyan)
                            .frame(width: geo.size.width * CGFloat(language.progress), height: 4)
                    }
                }
                .frame(height: 4)
                .padding(.top, AppSpacing.xs)
            }
            .padding(AppSpacing.md)
        }
    }
}

#Preview {
    NavigationStack {
        LanguageSelectionView()
    }
}
