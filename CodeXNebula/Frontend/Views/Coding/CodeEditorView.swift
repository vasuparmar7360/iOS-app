//
//  CodeEditorView.swift
//  CodeXNebula
//
//  The coding playground where the user writes and executes code.
//

import SwiftUI

struct CodeEditorView: View {
    @StateObject var viewModel: CodingViewModel
    @FocusState private var isEditorFocused: Bool
    @State private var showNeoChat: Bool = false
    
    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Text(viewModel.language.name)
                        .font(AppFonts.caption)
                        .foregroundColor(AppColors.neonCyan)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(AppColors.neonCyan.opacity(0.15))
                        .cornerRadius(6)
                    
                    Spacer()
                    
                    Button(action: { viewModel.resetCode() }) {
                        Image(systemName: "arrow.counterclockwise")
                            .foregroundColor(AppColors.textSecondary)
                            .padding(8)
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
                .background(AppColors.cardBackground)
                
                // Editor Area
                TextEditor(text: $viewModel.code)
                    .font(AppFonts.codeLarge)
                    .foregroundColor(AppColors.textPrimary)
                    .scrollContentBackground(.hidden)
                    .background(AppColors.backgroundSecondary)
                    .focused($isEditorFocused)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .padding(.horizontal, 4)
                    .onChange(of: viewModel.code) {
                        viewModel.saveDraft()
                    }
                
                // Toolbar (Run/Submit)
                HStack(spacing: AppSpacing.md) {
                    Button(action: {
                        isEditorFocused = false
                        Task {
                            await viewModel.runCode()
                        }
                    }) {
                        HStack {
                            if viewModel.isRunning && !viewModel.isSubmitting {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: AppColors.textPrimary))
                            } else {
                                Image(systemName: "play.fill")
                            }
                            Text("Run Code")
                                .font(AppFonts.buttonSecondary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(AppColors.cardBackground)
                        .foregroundColor(AppColors.textPrimary)
                        .cornerRadius(8)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(AppColors.borderSubtle, lineWidth: 1))
                    }
                    .disabled(viewModel.isRunning || viewModel.isSubmitting)
                    
                    Button(action: {
                        isEditorFocused = false
                        Task {
                            await viewModel.submitSolution()
                        }
                    }) {
                        HStack {
                            if viewModel.isSubmitting {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: AppColors.background))
                            } else {
                                Image(systemName: "paperplane.fill")
                            }
                            Text("Submit")
                                .font(AppFonts.buttonSecondary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(AppColors.neonCyan)
                        .foregroundColor(AppColors.background)
                        .cornerRadius(8)
                    }
                    .disabled(viewModel.isRunning || viewModel.isSubmitting)
                }
                .padding()
                .background(AppColors.cardBackground)
            }
            
            // Console / Run Result Overlay
            if let result = viewModel.executionResult, !viewModel.showResult {
                VStack {
                    Spacer()
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Console Output")
                                .font(AppFonts.headline)
                                .foregroundColor(AppColors.textPrimary)
                            Spacer()
                            Button(action: { viewModel.executionResult = nil }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(AppColors.textSecondary)
                            }
                        }
                        
                        Text(result.status.rawValue)
                            .font(AppFonts.caption)
                            .foregroundColor(result.status.color)
                        
                        ScrollView {
                            Text(result.output)
                                .font(AppFonts.code)
                                .foregroundColor(AppColors.textSecondary)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .frame(maxHeight: 150)
                    }
                    .padding()
                    .background(AppColors.backgroundSecondary)
                    .cornerRadius(16, corners: [.topLeft, .topRight])
                    .shadow(color: Color.black.opacity(0.3), radius: 10, y: -5)
                }
                .transition(.move(edge: .bottom))
                .animation(.easeInOut, value: viewModel.executionResult != nil)
            }
            
            // Floating Ask NEO Button
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        isEditorFocused = false
                        showNeoChat = true
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: "sparkles")
                                .font(.system(size: 16))
                            Text("Ask NEO")
                                .font(AppFonts.buttonPrimary)
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                        .background(
                            AppColors.gradientPrimary
                        )
                        .cornerRadius(25)
                        .shadow(color: AppColors.neonCyan.opacity(0.4), radius: 10, y: 5)
                    }
                    .padding(.bottom, 90)
                    .padding(.trailing, 20)
                }
            }
        }
        .sheet(isPresented: $showNeoChat) {
            NeoChatView(
                viewModel: NeoAIViewModel(problem: viewModel.problem),
                code: viewModel.code,
                languageId: viewModel.language.id
            )
        }
        .navigationTitle("Editor")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    UIPasteboard.general.string = viewModel.code
                }) {
                    Image(systemName: "doc.on.doc")
                        .foregroundColor(AppColors.neonCyan)
                }
            }
        }
        .navigationDestination(isPresented: $viewModel.showResult) {
            if let result = viewModel.executionResult {
                ResultView(result: result, problem: viewModel.problem)
            }
        }
    }
}

