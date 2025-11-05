//
//  PlayPauseIcon.swift
//  MusicPlayer
//
//  Created by Winston Du on 11/4/25.
//

import SwiftUI

struct PlayPauseIcon: View {
    @Binding var isPlaying: Bool

    let size: CGFloat
    
    let foregroundColor: Color = Colors.surfaceColor
    
    //
    
    // slightly move play arrow to the right
    var playArrowOffset: CGFloat {
        CGFloat(Int(size * 0.02) + 1)
    }

    var body: some View {
        ZStack {
            // Play icon
            Image("play_arrow", bundle: .main)
                .font(.system(size: size + 1))
                .fontWeight(.light)
                .foregroundStyle(foregroundColor)
                .opacity(!isPlaying ? 1 : 0)
                .offset(x: playArrowOffset)

            // Pause icon
            Image("pause", bundle: .main)
                .font(.system(size: size))
                .fontWeight(.light)
                .foregroundStyle(foregroundColor)
                .opacity(isPlaying ? 1 : 0)
        }
        .frame(width: size, height: size)
        .releaseAction {
            isPlaying.toggle()
        }
    }
}

// MARK: - Standalone Preview Version

struct PlayPauseIconStandalone: View {
    @State private var isPlaying: Bool
    var size: CGFloat = 24

    var body: some View {
        PlayPauseIcon(isPlaying: $isPlaying, size: size)
    }

    init(isPlaying: Bool = false, size: CGFloat = 24) {
        self._isPlaying = State(initialValue: isPlaying)
        self.size = size
    }
}

// MARK: - Previews

#Preview("Play Button") {
    ZStack {
        PlayPauseIconStandalone(size: 48)
            .hapticFeedback()
            .pressScale()
            .circularRipple()
            .padding()
        Color.gray.opacity(0.3)
    }
}
