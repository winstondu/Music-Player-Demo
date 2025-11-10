//
//  MockTrackPlayer.swift
//  MusicPlayer
//
//  Created by Winston Du on 11/9/25.
//

import Combine
import Foundation
import SwiftUI

@MainActor
class MockTrackPlayer: ObservableObject, TrackPlayerProtocol {
    @Published private(set) var currentTrack: MusicTrack?
    @Published private(set) var isPlaying: Bool = false
    @Published var repeatState: RepeatState = .repeatOff
    @Published private(set) var currentTime: TimeInterval = 0
    @Published private(set) var bufferedTime: TimeInterval = 0
    @Published private(set) var isBuffering: Bool = false

    nonisolated(unsafe) private var timer: Timer?
    nonisolated(unsafe) private var bufferingTimer: Timer?
    private let playbackInterval: TimeInterval = 0.1
    private let bufferingInterval: TimeInterval = 0.1
    private let bufferingSpeed: TimeInterval = 10.0  // Buffer 10 seconds per real second

    // Computed duration based on current track's trackTimeMillis
    var duration: TimeInterval {
        currentTrack?.durationSeconds ?? 0
    }

    func setTrack(_ track: MusicTrack?) {
        if isPlaying {
            pause()
        }
        if isBuffering {
            stopBuffering()
        }
        currentTrack = track
        currentTime = 0
        bufferedTime = 0
    }

    func play() {
        guard currentTrack != nil else { return }

        isPlaying = true
        startTimer()
        print("Mock player: Started playing")
    }

    func pause() {
        isPlaying = false
        stopTimer()
        print("Mock player: Paused")
    }

    func resume() {
        guard currentTrack != nil else { return }

        isPlaying = true
        startTimer()
        print("Mock player: Resumed")
    }

    func seek(to time: TimeInterval) {
        currentTime = min(max(0, time), duration)
        print("Mock player: Seeked to \(currentTime)s")
    }

    func togglePlayPause() {
        if isPlaying {
            pause()
        } else {
            if currentTrack != nil {
                if currentTime > 0 {
                    resume()
                } else {
                    play()
                }
            }
        }
    }

    func bufferMore(seconds: TimeInterval) {
        bufferedTime = min(bufferedTime + seconds, duration)
        print("Mock player: Buffered to \(bufferedTime)s")
    }

    func beginBuffering() {
        guard currentTrack != nil else { return }
        guard !isBuffering else { return }

        isBuffering = true
        startBufferingTimer()
        print("Mock player: Started buffering")
    }

    func stopBuffering() {
        isBuffering = false
        stopBufferingTimer()
        print("Mock player: Stopped buffering")
    }

    func resetBuffering() {
        bufferedTime = currentTime
        print("Mock player: Reset buffering to \(currentTime)s")
    }

    // MARK: - Private Methods

    private func startTimer() {
        stopTimer()
        timer = Timer.scheduledTimer(withTimeInterval: playbackInterval, repeats: true) {
            [weak self] _ in
            Task { @MainActor [weak self] in
                guard let self = self else { return }

                if self.currentTime >= self.duration {
                    self.handlePlaybackEnd()
                } else {
                    self.currentTime += self.playbackInterval

                    // Auto-buffer slightly ahead of current time
                    if self.bufferedTime < self.currentTime + 10 {
                        self.bufferedTime = min(self.currentTime + 10, self.duration)
                    }
                }
            }
        }
    }

    nonisolated private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    private func startBufferingTimer() {
        stopBufferingTimer()
        bufferingTimer = Timer.scheduledTimer(
            withTimeInterval: bufferingInterval,
            repeats: true
        ) { [weak self] _ in
            Task { @MainActor [weak self] in
                guard let self = self else { return }

                if self.bufferedTime >= self.duration {
                    self.stopBuffering()
                } else {
                    let increment = self.bufferingSpeed * self.bufferingInterval
                    self.bufferedTime = min(self.bufferedTime + increment, self.duration)
                }
            }
        }
    }

    nonisolated private func stopBufferingTimer() {
        bufferingTimer?.invalidate()
        bufferingTimer = nil
    }

    private func handlePlaybackEnd() {
        print("Mock player: Playback ended")
        isPlaying = false
        stopTimer()
    }

    deinit {
        stopTimer()
        stopBufferingTimer()
    }
}
