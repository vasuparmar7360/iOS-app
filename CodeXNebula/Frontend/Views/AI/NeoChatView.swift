import SwiftUI

struct NeoChatView: View {
    @ObservedObject var viewModel: NeoAIViewModel
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) var dismiss
    
    let code: String
    let languageId: String
    
    @State private var showingHintConfirmation = false
    
    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.down")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(AppColors.textPrimary)
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 8) {
                        Image(systemName: "cpu")
                            .foregroundColor(AppColors.neonCyan)
                        Text("NEO Mentor")
                            .appFont(AppFonts.headline)
                            .foregroundColor(AppColors.textPrimary)
                    }
                    
                    Spacer()
                    
                    // Invisible spacer for balance
                    Image(systemName: "chevron.down")
                        .font(.system(size: 20))
                        .foregroundColor(.clear)
                }
                .padding()
                .background(AppColors.backgroundSecondary)
                
                // Chat List
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(spacing: AppSpacing.md) {
                            ForEach(viewModel.messages) { message in
                                ChatBubble(message: message)
                                    .id(message.id)
                            }
                            
                            if viewModel.isTyping {
                                TypingIndicator()
                                    .id("typing")
                            }
                        }
                        .padding()
                    }
                    .onChange(of: viewModel.messages.count) {
                        if let lastId = viewModel.messages.last?.id {
                            withAnimation {
                                proxy.scrollTo(lastId, anchor: .bottom)
                            }
                        }
                    }
                    .onChange(of: viewModel.isTyping) {
                        if viewModel.isTyping {
                            withAnimation {
                                proxy.scrollTo("typing", anchor: .bottom)
                            }
                        }
                    }
                }
                
                Divider().background(AppColors.borderSubtle)
                
                // Action Chips
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: AppSpacing.sm) {
                        ActionButton(title: "Get Hint (10 XP)", icon: "lightbulb.fill") {
                            showingHintConfirmation = true
                        }
                        ActionButton(title: "Explain Problem", icon: "questionmark.circle") {
                            Task { await viewModel.requestExplanation() }
                        }
                        ActionButton(title: "Review My Code", icon: "magnifyingglass") {
                            Task { await viewModel.requestCodeReview(code: code, languageId: languageId) }
                        }
                        ActionButton(title: "Find Bugs", icon: "ladybug") {
                            Task { await viewModel.requestBugFind(code: code, languageId: languageId) }
                        }
                        ActionButton(title: "Optimize Code", icon: "bolt.fill") {
                            Task { await viewModel.requestOptimization(code: code, languageId: languageId) }
                        }
                        ActionButton(title: "Time Complexity", icon: "clock") {
                            Task { await viewModel.requestTimeComplexity(code: code) }
                        }
                        ActionButton(title: "Space Complexity", icon: "memorychip") {
                            Task { await viewModel.requestSpaceComplexity(code: code) }
                        }
                        ActionButton(title: "Learning Suggestions", icon: "graduationcap") {
                            Task { await viewModel.requestLearningSuggestions(code: code) }
                        }
                    }
                    .padding()
                }
                .background(AppColors.backgroundSecondary)
                .disabled(viewModel.isTyping)
            }
            
            if showingHintConfirmation {
                HintPopupView(
                    xpCost: 10,
                    onConfirm: {
                        showingHintConfirmation = false
                        Task { await viewModel.requestHint(code: code, appState: appState) }
                    },
                    onCancel: {
                        showingHintConfirmation = false
                    }
                )
            }
        }
    }
}

// MARK: - Components

struct ChatBubble: View {
    let message: AIMessage
    
    var body: some View {
        HStack {
            if message.role == .user { Spacer() }
            
            VStack(alignment: message.role == .user ? .trailing : .leading, spacing: 4) {
                Text(message.role == .user ? "You" : "NEO")
                    .font(AppFonts.caption)
                    .foregroundColor(AppColors.textSecondary)
                
                Text(.init(message.content))
                    .appFont(AppFonts.body)
                    .foregroundColor(AppColors.textPrimary)
                    .padding(AppSpacing.md)
                    .background(message.role == .user ? AppColors.blueAccent.opacity(0.3) : AppColors.cardBackground)
                    .cornerRadius(16, corners: message.role == .user ? [.topLeft, .topRight, .bottomLeft] : [.topLeft, .topRight, .bottomRight])
                    .overlay(
                        RoundedCorner(radius: 16, corners: message.role == .user ? [.topLeft, .topRight, .bottomLeft] : [.topLeft, .topRight, .bottomRight])
                            .stroke(message.role == .user ? AppColors.blueAccent : AppColors.borderSubtle, lineWidth: 1)
                    )
            }
            
            if message.role == .neo { Spacer() }
        }
    }
}

struct TypingIndicator: View {
    @State private var phase = 0.0
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("NEO")
                    .font(AppFonts.caption)
                    .foregroundColor(AppColors.textSecondary)
                
                HStack(spacing: 4) {
                    ForEach(0..<3) { index in
                        Circle()
                            .fill(AppColors.neonCyan)
                            .frame(width: 8, height: 8)
                            .offset(y: sin(phase + Double(index) * 1.5) * 4)
                    }
                }
                .padding(AppSpacing.md)
                .background(AppColors.cardBackground)
                .cornerRadius(16, corners: [.topLeft, .topRight, .bottomRight])
                .overlay(
                    RoundedCorner(radius: 16, corners: [.topLeft, .topRight, .bottomRight])
                        .stroke(AppColors.borderSubtle, lineWidth: 1)
                )
            }
            Spacer()
        }
        .onAppear {
            withAnimation(.linear(duration: 1.0).repeatForever(autoreverses: false)) {
                phase = .pi * 2
            }
        }
    }
}

struct ActionButton: View {
    let title: String
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 14))
                Text(title)
                    .font(AppFonts.caption)
            }
            .foregroundColor(AppColors.neonCyan)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(AppColors.neonCyan.opacity(0.1))
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(AppColors.neonCyan.opacity(0.3), lineWidth: 1)
            )
        }
    }
}
