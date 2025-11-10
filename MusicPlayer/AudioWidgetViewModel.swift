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

    @Published private var internalCurrentTime: TimeInterval = 0
    private var wasPlayingBeforeInteraction: Bool = false
    @Published private(set) var isInteractingWithSlider: Bool = false

    var currentTime: TimeInterval {
        if isInteractingWithSlider {
            return internalCurrentTime
        } else {
            return player?.currentTime ?? 0
        }
    }

    init(player: Player) {
        self.player = player
    }

    func beginSliderInteraction() {
        guard let player = player else { return }
        guard let trackPlayer = player as? TrackPlayer else { return }

        isInteractingWithSlider = true
        wasPlayingBeforeInteraction = player.isPlaying

        trackPlayer.pause()
    }
    
    func updateSliderTime(_ time: TimeInterval) {
        self.internalCurrentTime = time
    }

    func endSliderInteraction() {
        guard let player = player else { return }
        guard let trackPlayer = player as? TrackPlayer else { return }

        isInteractingWithSlider = false

        // Seek to the committed time
        trackPlayer.seek(to: internalCurrentTime)

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
                trackPlayer.resume()
            }
        }
    }
}
