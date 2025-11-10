//
//  AudioWidget.swift
//  MusicPlayer
//
//  Created by Winston Du on 11/4/25.
//

import SwiftUI

struct AudioWidget<Player: TrackPlayerProtocol>: View {
    @ObservedObject var player: Player
    var preferences: any UserPreferencesProtocol

    @StateObject private var viewModel: AudioWidgetViewModel<Player>

    init(player: Player, preferences: any UserPreferencesProtocol) {
        self.player = player
        self.preferences = preferences
        self._viewModel = StateObject(wrappedValue: AudioWidgetViewModel(player: player))
    }

    var isTrackLoaded: Bool {
        player.currentTrack != nil
    }

    var isFavorite: Bool {
        guard let trackId = player.currentTrack?.id else { return false }
        return preferences.isFavorite(trackId: trackId)
    }

    var duration: TimeInterval {
        // Duration is derived from the track
        return player.currentTrack?.durationSeconds ?? 0
    }

    // Custom bindings
    private var currentTimeBinding: Binding<TimeInterval> {
        Binding(
            get: { self.viewModel.currentTime },
            set: { newValue in
                self.viewModel.updateSliderTime(newValue)
            }
        )
    }

    private var repeatStateBinding: Binding<RepeatState> {
        player.binding(for: \.repeatState)
    }

    private var isPlayingBinding: Binding<Bool> {
        Binding(
            get: { self.player.isPlaying },
            set: { _ in
                self.player.togglePlayPause()
            }
        )
    }

    private var isFavoriteBinding: Binding<Bool> {
        Binding(
            get: { self.isFavorite },
            set: { newValue in
                guard let trackId = self.player.currentTrack?.id else { return }
                self.preferences.setFavorite(newValue, for: trackId)
            }
        )
    }

    var body: some View {
        ZStack(alignment: .center) {
            Colors.background
            VStack(spacing: 0) {
                Spacer()
                TrackDisplayView(track: player.currentTrack, artworkSize: 88)
                    .frame(width: 416)

                Color.clear.frame(height: 30)

                TimelineSlider(
                    currentTime: currentTimeBinding,
                    bufferedTime: player.bufferedTime,
                    duration: duration,
                    onInteractionStart: {
                        viewModel.beginSliderInteraction()
                    },
                    onInteractionEnd: {
                        viewModel.endSliderInteraction()
                    }
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
            RepeatIcon(repeatState: repeatStateBinding, size: 24, frameSize: 36)
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

            PlayPauseIcon(isPlaying: isPlayingBinding, size: 48)
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

            FavoriteHeartIcon(isFavorite: isFavoriteBinding, heartSize: 24, frameSize: 36)
                .hapticFeedback()
                .allowsHitTesting(isTrackLoaded)
        }
    }
}
