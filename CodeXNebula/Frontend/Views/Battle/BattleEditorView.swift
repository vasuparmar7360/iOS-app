//
//  BattleEditorView.swift
//  CodeXNebula
//

import SwiftUI

struct BattleEditorView: View {
    @ObservedObject var viewModel: BattleArenaViewModel
    @FocusState private var isEditorFocused: Bool
    
    var body: some View {
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
                .disabled(viewModel.state != .playing)
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
                .disabled(viewModel.state != .playing)
            
            // Execution Result
            if let result = viewModel.executionResult {
                VStack(alignment: .leading, spacing: 4) {
                    Text(result.status.rawValue)
                        .font(AppFonts.headline)
                        .foregroundColor(result.status.color)
                    Text(result.output)
                        .font(AppFonts.code)
                        .foregroundColor(AppColors.textSecondary)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(AppColors.cardBackground)
                .border(AppColors.borderSubtle, width: 1)
            }
            
            // Toolbar (Run/Submit)
            HStack(spacing: AppSpacing.md) {
                Button(action: {
                    isEditorFocused = false
                    Task { await viewModel.runCode() }
                }) {
                    HStack {
                        if viewModel.isRunningCode {
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
                .disabled(viewModel.isRunningCode || viewModel.state != .playing)
                
                Button(action: {
                    isEditorFocused = false
                    Task { await viewModel.submitCode() }
                }) {
                    HStack {
                        if viewModel.state == .submitting {
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
                    .background(AppColors.gradientPrimary)
                    .foregroundColor(AppColors.background)
                    .cornerRadius(8)
                }
                .disabled(viewModel.state != .playing)
            }
            .padding()
            .background(AppColors.background)
        }
    }
}
