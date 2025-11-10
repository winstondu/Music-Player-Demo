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

    let scrollDuration = 6.0

    @State private var textWidth: CGFloat = 0
    @State private var containerWidth: CGFloat = 0
    @State private var isMarqueeActive: Bool = false
    @State private var scrollContentID = UUID()

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
                    .id("measurement")
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
                                .id("text-1-\(text)")

                            if shouldScroll {
                                Text(text)
                                    .font(font)
                                    .fixedSize()
                                    .id("text-2-\(text)")
                            }
                        }
                    }
                    .id(scrollContentID)
                    .scrollIndicators(.hidden)
                    .scrollDisabled(true)
                    .onChange(of: shouldScroll) { _, _ in
                        updateMarqueeState(proxy: proxy)
                    }
                    .onChange(of: text) { _, newText in
                        resetMarquee(proxy: proxy, newText: newText)
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

        withAnimation(.linear(duration: scrollDuration)) {
            proxy.scrollTo("text-2-\(text)", anchor: .leading)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + scrollDuration) {
            // Reset to start position without animation
            proxy.scrollTo("text-1-\(self.text)", anchor: .leading)

            guard isMarqueeActive else { return }
            // Continue the loop
            DispatchQueue.main.async {
                animateMarquee(proxy: proxy)
            }
        }
    }

    private func stopMarquee(proxy: ScrollViewProxy) {
        isMarqueeActive = false
        proxy.scrollTo("text-1-\(text)", anchor: .leading)
    }

    private func resetMarquee(proxy: ScrollViewProxy, newText: String) {
        isMarqueeActive = false
        scrollContentID = UUID()
        withAnimation(nil) {
            proxy.scrollTo("text-1-\(newText)", anchor: .leading)
        }
    }
}
