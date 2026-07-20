//
//  AppAnimations.swift
//  CodeXNebula
//
//  Reusable animation tokens and ViewModifiers.
//  All transitions and interactive animations are defined here.
//

import SwiftUI

// MARK: - Animation Tokens

enum AppAnimation {

    // -------------------------------------------------------------------------
    // MARK: Durations
    // -------------------------------------------------------------------------

    static let durationFast:    Double = 0.18
    static let durationNormal:  Double = 0.28
    static let durationSlow:    Double = 0.45
    static let durationVerySlow: Double = 0.7

    // -------------------------------------------------------------------------
    // MARK: Named Animations
    // -------------------------------------------------------------------------

    /// Smooth ease-out — general UI transitions.
    static let standard  = Animation.easeOut(duration: durationNormal)

    /// Spring — interactive elements like buttons/cards.
    static let spring    = Animation.spring(response: 0.38, dampingFraction: 0.72)

    /// Bouncy spring — playful game elements.
    static let bounce    = Animation.spring(response: 0.45, dampingFraction: 0.55)

    /// Snappy spring — fast confirmations/taps.
    static let snappy    = Animation.spring(response: 0.25, dampingFraction: 0.80)

    /// Gentle ease — fades and opacity changes.
    static let fade      = Animation.easeInOut(duration: durationSlow)

    /// Screen entrance — slide + fade.
    static let screenIn  = Animation.easeOut(duration: durationSlow)

    /// Slow hero element entrance.
    static let heroIn    = Animation.spring(response: 0.7, dampingFraction: 0.65)

    /// Pulsing loop — neon glow heartbeat.
    static let pulse     = Animation.easeInOut(duration: 1.4).repeatForever(autoreverses: true)

    /// Progress fill.
    static let progress  = Animation.easeInOut(duration: 0.9)
}

// MARK: - Button Press Modifier

struct ButtonPressModifier: ViewModifier {
    @State private var isPressed = false

    func body(content: Content) -> some View {
        content
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .opacity(isPressed ? 0.88 : 1.0)
            .animation(AppAnimation.snappy, value: isPressed)
            .onLongPressGesture(minimumDuration: 99, pressing: { pressing in
                isPressed = pressing
            }, perform: {})
    }
}

// MARK: - Appearance Modifiers

struct FadeInModifier: ViewModifier {
    let delay: Double
    @State private var appeared = false

    func body(content: Content) -> some View {
        content
            .opacity(appeared ? 1 : 0)
            .onAppear {
                withAnimation(AppAnimation.fade.delay(delay)) {
                    appeared = true
                }
            }
    }
}

struct SlideUpModifier: ViewModifier {
    let delay: Double
    let offset: CGFloat
    @State private var appeared = false

    func body(content: Content) -> some View {
        content
            .opacity(appeared ? 1 : 0)
            .offset(y: appeared ? 0 : offset)
            .onAppear {
                withAnimation(AppAnimation.screenIn.delay(delay)) {
                    appeared = true
                }
            }
    }
}

struct ScaleInModifier: ViewModifier {
    let delay: Double
    @State private var appeared = false

    func body(content: Content) -> some View {
        content
            .opacity(appeared ? 1 : 0)
            .scaleEffect(appeared ? 1 : 0.80)
            .onAppear {
                withAnimation(AppAnimation.spring.delay(delay)) {
                    appeared = true
                }
            }
    }
}

struct PulseModifier: ViewModifier {
    @State private var pulsing = false

    func body(content: Content) -> some View {
        content
            .scaleEffect(pulsing ? 1.05 : 1.0)
            .onAppear {
                withAnimation(AppAnimation.pulse) {
                    pulsing = true
                }
            }
    }
}

// MARK: - Transition Definitions

extension AnyTransition {
    /// Slide from bottom + fade — default screen push.
    static var slideUp: AnyTransition {
        .asymmetric(
            insertion: .move(edge: .bottom).combined(with: .opacity),
            removal:   .move(edge: .top).combined(with: .opacity)
        )
    }

    /// Scale + fade — modal / overlay entrance.
    static var scaleAndFade: AnyTransition {
        .scale(scale: 0.88).combined(with: .opacity)
    }

    /// Card flip-in effect.
    static var cardAppear: AnyTransition {
        .asymmetric(
            insertion: .scale(scale: 0.94).combined(with: .opacity),
            removal:   .opacity
        )
    }
}

// MARK: - View Extensions

extension View {

    /// Subtle press-down feedback for interactive elements.
    func pressAnimation() -> some View {
        modifier(ButtonPressModifier())
    }

    /// Fade in on appear with optional delay.
    func fadeIn(delay: Double = 0) -> some View {
        modifier(FadeInModifier(delay: delay))
    }

    /// Slide up + fade on appear with optional delay.
    func slideUp(delay: Double = 0, offset: CGFloat = 30) -> some View {
        modifier(SlideUpModifier(delay: delay, offset: offset))
    }

    /// Scale in + fade on appear with optional delay.
    func scaleIn(delay: Double = 0) -> some View {
        modifier(ScaleInModifier(delay: delay))
    }

    /// Gentle repeating pulse scale effect.
    func pulseEffect() -> some View {
        modifier(PulseModifier())
    }
}
