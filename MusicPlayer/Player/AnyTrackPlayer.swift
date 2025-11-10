//
//  AnyTrackPlayer.swift
//  MusicPlayer
//
//  Created by Winston Du on 11/9/25.
//

import Combine
import Foundation

/// Type-erased wrapper for TrackPlayerProtocol that forwards ObservableObject conformance
@MainActor
class AnyTrackPlayer: ObservableObject, TrackPlayerProtocol {
    private let _currentTrack: () -> MusicTrack?
    private let _isPlaying: () -> Bool
    private let _repeatState: () -> RepeatState
    private let _setRepeatState: (RepeatState) -> Void
    private let _currentTime: () -> TimeInterval
    private let _bufferedTime: () -> TimeInterval
    private let _togglePlayPause: () -> Void
    private let _pause: () -> Void
    private let _resume: () -> Void
    private let _seek: (TimeInterval) -> Void

    private var cancellable: AnyCancellable?

    init<P: TrackPlayerProtocol>(_ player: P) {
        // Capture closures for all properties and methods
        _currentTrack = { player.currentTrack }
        _isPlaying = { player.isPlaying }
        _repeatState = { player.repeatState }
        _setRepeatState = { player.repeatState = $0 }
        _currentTime = { player.currentTime }
        _bufferedTime = { player.bufferedTime }
        _togglePlayPause = player.togglePlayPause
        _pause = player.pause
        _resume = player.resume
        _seek = player.seek

        // Forward objectWillChange from wrapped player to this wrapper
        // This ensures SwiftUI observes changes correctly
        cancellable = player.objectWillChange.sink { [weak self] _ in
            self?.objectWillChange.send()
        }
    }

    // MARK: - TrackPlayerProtocol Conformance

    var currentTrack: MusicTrack? {
        _currentTrack()
    }

    var isPlaying: Bool {
        _isPlaying()
    }

    var repeatState: RepeatState {
        get { _repeatState() }
        set { _setRepeatState(newValue) }
    }

    var currentTime: TimeInterval {
        _currentTime()
    }

    var bufferedTime: TimeInterval {
        _bufferedTime()
    }

    func togglePlayPause() {
        _togglePlayPause()
    }

    func pause() {
        _pause()
    }

    func resume() {
        _resume()
    }

    func seek(to time: TimeInterval) {
        _seek(time)
    }
}
