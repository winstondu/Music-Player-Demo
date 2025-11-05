//
//  AudioWidget.swift
//  MusicPlayer
//
//  Created by Winston Du on 11/4/25.
//

import SwiftUI

struct AudioWidget: View {
    @Binding var currentTrack: MusicTrack?
    @Binding var isPlaying: Bool
    @Binding var isFavorite: Bool
    @Binding var repeatState: RepeatState
    @Binding var currentTime: TimeInterval
    @Binding var bufferedTime: TimeInterval

    var isTrackLoaded: Bool {
        currentTrack != nil
    }

    var duration: TimeInterval {
        // Duration is derived from the track
        // In real implementation, this would come from the track metadata or audio player
        isTrackLoaded ? 300 : 0  // 5 minutes when track is loaded, 0 when no track
    }

    var body: some View {
        ZStack(alignment: .center) {
            Colors.background
            VStack(spacing: 0) {
                Spacer()
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
                .allowsHitTesting(isTrackLoaded)

                Color.clear.frame(height: 16)

                widgetBottomControls
                Spacer()
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
                .allowsHitTesting(isTrackLoaded)

            PlayPauseIcon(isPlaying: $isPlaying, size: 48)
                .pressScale()
                .hapticFeedback()
                .circularRipple(diameter: 72)
                .allowsHitTesting(isTrackLoaded)

            SkipIcon(direction: .right, size: 36, frameSize: 36)
                .pressScale()
                .hapticFeedback()
                .circularRipple(diameter: 48)
                .releaseAction {
                    print("Next")
                }
                .allowsHitTesting(isTrackLoaded)

            FavoriteHeartIcon(isFavorite: $isFavorite, heartSize: 24, frameSize: 36)
                .hapticFeedback()
                .allowsHitTesting(isTrackLoaded)
        }
    }
}
