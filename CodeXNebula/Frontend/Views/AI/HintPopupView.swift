import SwiftUI

struct HintPopupView: View {
    let xpCost: Int
    let onConfirm: () -> Void
    let onCancel: () -> Void
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
            
            GlassCard {
                VStack(spacing: AppSpacing.lg) {
                    Image(systemName: "lightbulb.fill")
                        .font(.system(size: 40))
                        .foregroundColor(AppColors.warning)
                    
                    Text("Request Hint?")
                        .appFont(AppFonts.title2)
                        .foregroundColor(AppColors.textPrimary)
                    
                    Text("This will cost \(xpCost) XP.")
                        .appFont(AppFonts.body)
                        .foregroundColor(AppColors.textSecondary)
                        .multilineTextAlignment(.center)
                    
                    HStack(spacing: AppSpacing.md) {
                        Button(action: onCancel) {
                            Text("Cancel")
                                .appFont(AppFonts.buttonPrimary)
                                .foregroundColor(AppColors.textPrimary)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(AppColors.cardBackground)
                                .cornerRadius(12)
                        }
                        
                        Button(action: onConfirm) {
                            Text("Confirm")
                                .appFont(AppFonts.buttonPrimary)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(AppColors.gradientPrimary)
                                .cornerRadius(12)
                        }
                    }
                }
                .padding(AppSpacing.xl)
            }
            .frame(maxWidth: 320)
        }
    }
}
