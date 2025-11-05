//
//  AudioWidget.swift
//  MusicPlayer
//
//  Created by Winston Du on 11/4/25.
//

import SwiftUI

struct AudioWidget: View {
    @State var currentTrack: MusicTrack

    @State var isPlaying: Bool
    @State var isFavorite: Bool
    @State var repeatState: RepeatState = .repeatOff

    @State var currentTime: TimeInterval = 0
    @State var bufferedTime: TimeInterval = 60
    let duration: TimeInterval = 300  // 5 minutes

    var body: some View {
        ZStack(alignment: .center) {
            Colors.background
            VStack(spacing: 0) {
                TrackDisplayView(track: currentTrack, artworkSize: 88)
                    .frame(width: 416)

                Color.clear.frame(height: 30)

                TimelineSlider(
                    currentTime: $currentTime,
                    bufferedTime: $bufferedTime,
                    duration: duration
                ) {
                    Circle()
                        .foregroundColor(.white)
                        .frame(width: 12, height: 12)
                        .pressScale(1.25)
                        .hapticFeedback(onStart: true, onEnd: true)
                }
                .frame(maxWidth: 416)

                Color.clear.frame(height: 16)

                widgetBottomControls
            }
        }
        .frame(maxWidth: 480, maxHeight: 300)
        .cornerRadius(16)
    }

    @ViewBuilder
    var widgetBottomControls: some View {
        HStack(spacing: 24) {
            RepeatIcon(repeatState: $repeatState, size: 24, frameSize: 36)
                .pressScale()
                .hapticFeedback()
                .circularRipple(diameter: 48)

            SkipIcon(direction: .left, size: 36, frameSize: 36)
                .pressScale()
                .hapticFeedback()
                .circularRipple(diameter: 48)
                .releaseAction {
                    print("Previous")
                }

            PlayPauseIcon(isPlaying: $isPlaying, size: 48)
                .pressScale()
                .hapticFeedback()
                .circularRipple(diameter: 72)

            SkipIcon(direction: .right, size: 36, frameSize: 36)
                .pressScale()
                .hapticFeedback()
                .circularRipple(diameter: 48)
                .releaseAction {
                    print("Next")
                }

            FavoriteHeartIcon(isFavorite: $isFavorite, heartSize: 24, frameSize: 36)
                .hapticFeedback()

        }
    }
}
