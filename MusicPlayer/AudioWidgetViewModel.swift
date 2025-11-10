//
//  AudioWidgetViewModel.swift
//  MusicPlayer
//
//  Created by Winston Du on 11/9/25.
//

import Combine
import Foundation

@MainActor
class AudioWidgetViewModel<Player: TrackPlayerProtocol>: ObservableObject {
    private weak var player: Player?
    private let preferences: any UserPreferencesProtocol

    @Published private var internalCurrentTime: TimeInterval = 0
    private var wasPlayingBeforeInteraction: Bool = false
    @Published private(set) var isInteractingWithSlider: Bool = false
    @Published var isFavorite: Bool = false

    var currentTime: TimeInterval {
        if isInteractingWithSlider {
            return internalCurrentTime
        } else {
            return player?.currentTime ?? 0
        }
    }

    init(player: Player, preferences: any UserPreferencesProtocol) {
        self.player = player
        self.preferences = preferences
        self.updateFavoriteState()
    }

    func updateFavoriteState() {
        guard let trackId = player?.currentTrack?.id else {
            isFavorite = false
            return
        }
        isFavorite = preferences.isFavorite(trackId: trackId)
    }

    func toggleFavorite() {
        guard let trackId = player?.currentTrack?.id else { return }
        let newValue = !isFavorite
        preferences.setFavorite(newValue, for: trackId)
        isFavorite = newValue
    }

    func beginSliderInteraction() {
        guard let player = player else { return }

        // Always enter interaction mode regardless of concrete player type
        isInteractingWithSlider = true
        wasPlayingBeforeInteraction = player.isPlaying

        // Pause via protocol so both real and mock players support this
        player.pause()
    }
    
    func updateSliderTime(_ time: TimeInterval) {
        self.internalCurrentTime = time
    }

    func endSliderInteraction() {
        guard let player = player else { return }

        isInteractingWithSlider = false

        // Seek to the committed time via protocol
        player.seek(to: internalCurrentTime)

        // Check if seeking past buffered content (Case 3)
        let bufferedTime = player.bufferedTime
        if internalCurrentTime > bufferedTime {
            // Don't resume playback - pause regardless of previous state
            // Rationale: Prevents confusing UX where playback "starts" but no audio due to buffering
            print(
                "Seeking past buffered content (\(internalCurrentTime)s > \(bufferedTime)s) - pausing playback"
            )
        } else {
            // Cases 1 & 2: Resume playback if it was playing before
            if wasPlayingBeforeInteraction {
                player.resume()
            }
        }
    }
}
