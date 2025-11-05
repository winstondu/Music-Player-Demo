//
//  CircularRippleModifier.swift
//  MusicPlayer
//
//  Created by Winston Du on 11/4/25.
//

import SwiftUI

struct CircularBackgroundModifier: ViewModifier {
    let backgroundColor: Color
    let diameter: CGFloat

    @State private var isPressed = false
    @State private var showRipple = false

    func body(content: Content) -> some View {
        content
            .background {
                Circle()
                    .fill(backgroundColor)
                    .opacity(showRipple ? 1 : 0)
                    .animation(.easeIn(duration: 0.4), value: showRipple)
                    .frame(width: diameter, height: diameter)
            }
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in
                        if !isPressed {
                            isPressed = true
                            showRipple = true
                        }
                    }
                    .onEnded { _ in
                        isPressed = false
                        showRipple = false
                    }
            )
    }
}

extension View {
    func circularRipple(
        backgroundColor: Color = Colors.selectedBackground,
        diameter: CGFloat = 72
    ) -> some View {
        modifier(
            CircularBackgroundModifier(
                backgroundColor: backgroundColor,
                diameter: diameter
            ))
    }
}
