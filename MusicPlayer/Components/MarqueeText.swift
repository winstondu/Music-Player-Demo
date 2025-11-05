//
//  MarqueeText.swift
//  MusicPlayer
//
//  Created by Winston Du on 11/4/25.
//

import SwiftUI

struct MarqueeText: View {
    let text: String
    let font: Font
    let spacing: CGFloat // Spacing between repeated text in marquee

    @State private var textWidth: CGFloat = 0
    @State private var containerWidth: CGFloat = 0
    @State private var offset: CGFloat = 0
    @State private var isMarqueeActive: Bool = false
    @State private var animationID: UUID = UUID()

    init(text: String, font: Font, spacing: CGFloat = 40) {
        self.text = text
        self.font = font
        self.spacing = spacing
    }

    private var marqueeAnimation: Animation? {
        guard isMarqueeActive else { return nil }
        let totalWidth = textWidth + spacing
        return Animation.linear(duration: Double(totalWidth) / 30.0)
            .repeatForever(autoreverses: false)
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Measure the text width
                Text(text)
                    .font(font)
                    .fixedSize()
                    .background(
                        GeometryReader { textGeometry in
                            Color.clear
                                .onAppear {
                                    textWidth = textGeometry.size.width
                                    containerWidth = geometry.size.width
                                }
                                .onChange(of: geometry.size.width) { _, newWidth in
                                    containerWidth = newWidth
                                }
                        }
                    )
                    .opacity(0) // Hide the measurement text

                // Display text with conditional marquee
                HStack(spacing: spacing) {
                    Text(text)
                        .font(font)
                        .fixedSize()

                    Text(text)
                        .font(font)
                        .fixedSize()
                        .opacity(textWidth > containerWidth ? 1 : 0)
                }
                .offset(x: offset)
                .animation(marqueeAnimation, value: animationID)
                .onChange(of: textWidth) {
                    updateMarqueeState()
                }
                .onChange(of: containerWidth) {
                    updateMarqueeState()
                }
            }
            .frame(width: geometry.size.width, alignment: .leading)
            .clipped()
        }
    }

    private func updateMarqueeState() {
        let shouldScroll = textWidth > containerWidth

        if shouldScroll && !isMarqueeActive {
            startMarquee()
        } else if !shouldScroll && isMarqueeActive {
            stopMarquee()
        }
    }

    private func startMarquee() {
        isMarqueeActive = true
        let totalWidth = textWidth + spacing
        animationID = UUID() // Trigger new animation
        offset = -totalWidth
    }

    private func stopMarquee() {
        isMarqueeActive = false
        animationID = UUID() // Cancel animation
        offset = 0
    }
}
