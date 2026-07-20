//
//  AuthTextField.swift
//  CodeXNebula
//
//  Custom text field component tailored for the Authentication screens,
//  featuring glowing borders, SF symbols, and secure entry support.
//

import SwiftUI

struct AuthTextField: View {
    
    let icon: String
    let placeholder: String
    @Binding var text: String
    
    var isSecure: Bool = false
    var keyboardType: UIKeyboardType = .default
    var autoCapitalization: TextInputAutocapitalization = .never
    
    @FocusState private var isFocused: Bool
    @State private var showPassword: Bool = false
    
    var body: some View {
        HStack(spacing: AppSpacing.md) {
            Image(systemName: icon)
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(isFocused ? AppColors.neonCyan : AppColors.textTertiary)
                .frame(width: 24)
            
            Group {
                if isSecure && !showPassword {
                    SecureField(placeholder, text: $text)
                        .focused($isFocused)
                } else {
                    TextField(placeholder, text: $text)
                        .focused($isFocused)
                        .keyboardType(keyboardType)
                        .textInputAutocapitalization(autoCapitalization)
                        .autocorrectionDisabled(true)
                }
            }
            .font(AppFonts.body)
            .foregroundColor(AppColors.textPrimary)
            
            if isSecure {
                Button(action: { showPassword.toggle() }) {
                    Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                        .font(.system(size: 16))
                        .foregroundColor(AppColors.textTertiary)
                }
            }
        }
        .padding(.horizontal, AppSpacing.lg)
        .padding(.vertical, AppSpacing.md)
        .background(AppColors.cardBackground)
        .cornerRadius(AppRadius.button)
        .overlay(
            RoundedRectangle(cornerRadius: AppRadius.button)
                .strokeBorder(
                    isFocused ? AppColors.neonCyan.opacity(0.8) : AppColors.borderSubtle,
                    lineWidth: isFocused ? 1.5 : 1
                )
        )
        .shadow(
            color: isFocused ? AppColors.neonCyan.opacity(0.2) : .clear,
            radius: 8, x: 0, y: 0
        )
        .animation(AppAnimation.snappy, value: isFocused)
    }
}

#Preview {
    ZStack {
        AppColors.background.ignoresSafeArea()
        VStack(spacing: 20) {
            AuthTextField(icon: "envelope.fill", placeholder: "Email Address", text: .constant(""))
            AuthTextField(icon: "lock.fill", placeholder: "Password", text: .constant("secret"), isSecure: true)
        }
        .padding()
    }
}
