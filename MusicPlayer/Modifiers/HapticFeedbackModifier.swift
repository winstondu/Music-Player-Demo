//
//  HapticFeedbackModifier.swift
//  MusicPlayer
//
//  Created by Winston Du on 11/4/25.
//

import SwiftUI

struct HapticFeedbackModifier: ViewModifier {
    let hapticOnStart: Bool
    let hapticOnEnd: Bool

    @State private var hasTouchStarted: Bool = false

    func body(content: Content) -> some View {
        content
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in
                        if hapticOnStart && !hasTouchStarted {
                            hasTouchStarted = true
                            let impactMed = UIImpactFeedbackGenerator(style: .medium)
                            impactMed.impactOccurred()
                        }
                    }
                    .onEnded { _ in
                        hasTouchStarted = false
                        if hapticOnEnd {
                            let impactMed = UIImpactFeedbackGenerator(style: .medium)
                            impactMed.impactOccurred()
                        }
                    }
                )
    }
}

extension View {
    func hapticFeedback(onStart hapticOnStart: Bool = false, onEnd hapticOnEnd: Bool = true) -> some View {
        modifier(HapticFeedbackModifier(hapticOnStart: hapticOnStart, hapticOnEnd: hapticOnEnd))
    }
}
