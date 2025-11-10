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
    let spacing: CGFloat  // Spacing between repeated text in marquee

    @State private var textWidth: CGFloat = 0
    @State private var containerWidth: CGFloat = 0
    @State private var isMarqueeActive: Bool = false

    init(text: String, font: Font, spacing: CGFloat = 40) {
        self.text = text
        self.font = font
        self.spacing = spacing
    }

    var shouldScroll: Bool {
        textWidth > containerWidth
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
                                .onChange(of: textGeometry.size.width) { _, newWidth in
                                    textWidth = newWidth
                                }
                        }
                    )
                    .opacity(0)  // Hide the measurement text

                // ScrollView for marquee
                ScrollViewReader { proxy in
                    ScrollView(.horizontal) {
                        HStack(spacing: spacing) {
                            Text(text)
                                .font(font)
                                .fixedSize()
                                .id("text-1")

                            if shouldScroll {
                                Text(text)
                                    .font(font)
                                    .fixedSize()
                                    .id("text-2")
                            }
                        }
                    }
                    .scrollIndicators(.hidden)
                    .scrollDisabled(true)
                    .onChange(of: textWidth) { _, _ in
                        updateMarqueeState(proxy: proxy)
                    }
                    .onChange(of: containerWidth) { _, _ in
                        updateMarqueeState(proxy: proxy)
                    }
                    .onChange(of: text) { _, _ in
                        // Reset scroll position when text changes
                        isMarqueeActive = false
                        proxy.scrollTo("text-1", anchor: .leading)
                        updateMarqueeState(proxy: proxy)
                    }
                    .onAppear {
                        updateMarqueeState(proxy: proxy)
                    }
                }
            }
            .frame(width: geometry.size.width, alignment: .leading)
            .clipped()
        }
    }

    private func updateMarqueeState(proxy: ScrollViewProxy) {
        let shouldScroll = textWidth > containerWidth

        if shouldScroll && !isMarqueeActive {
            startMarquee(proxy: proxy)
        } else if !shouldScroll && isMarqueeActive {
            stopMarquee(proxy: proxy)
        }
    }

    private func startMarquee(proxy: ScrollViewProxy) {
        isMarqueeActive = true
        animateMarquee(proxy: proxy)
    }

    private func animateMarquee(proxy: ScrollViewProxy) {
        guard isMarqueeActive else { return }

        let duration = 2.5

        withAnimation(.linear(duration: duration)) {
            proxy.scrollTo("text-2", anchor: .leading)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            // Reset to start position without animation
            proxy.scrollTo("text-1", anchor: .leading)

            // Continue the loop
            DispatchQueue.main.async {
                animateMarquee(proxy: proxy)
            }
        }
    }

    private func stopMarquee(proxy: ScrollViewProxy) {
        isMarqueeActive = false
        proxy.scrollTo("text-1", anchor: .leading)
    }
}
