//
//  TrackPlayer.swift
//  MusicPlayer
//
//  Created by Winston Du on 11/4/25.
//

import AVFoundation
import Combine
import Foundation
import SwiftUI

/// Errors that can occur during track playback
enum TrackPlayerError: Error, LocalizedError {
    case assetNotFound(trackId: String)
    case loadFailed(trackId: String, underlyingError: Error)
    case playbackFailed(underlyingError: Error)

    var errorDescription: String? {
        switch self {
        case .assetNotFound(let trackId):
            return "Asset not found for track \(trackId)"
        case .loadFailed(let trackId, let error):
            return "Failed to load track \(trackId): \(error.localizedDescription)"
        case .playbackFailed(let error):
            return "Playback failed: \(error.localizedDescription)"
        }
    }
}

/// Represents the playback state of the player
enum PlaybackState {
    case idle
    case playing(trackId: String, currentTime: TimeInterval, duration: TimeInterval)
    case paused(trackId: String, currentTime: TimeInterval, duration: TimeInterval)
    case loading(trackId: String)
    case failed(error: TrackPlayerError)

    var currentTrackId: String? {
        switch self {
        case .playing(let trackId, _, _), .paused(let trackId, _, _), .loading(let trackId):
            return trackId
        case .idle, .failed:
            return nil
        }
    }

    var currentTime: TimeInterval? {
        switch self {
        case .playing(_, let time, _), .paused(_, let time, _):
            return time
        case .idle, .loading, .failed:
            return nil
        }
    }

    var duration: TimeInterval? {
        switch self {
        case .playing(_, _, let duration), .paused(_, _, let duration):
            return duration
        case .idle, .loading, .failed:
            return nil
        }
    }

    var isPlaying: Bool {
        if case .playing = self {
            return true
        }
        return false
    }

    var isPaused: Bool {
        if case .paused = self {
            return true
        }
        return false
    }
}

@MainActor
class TrackPlayer: ObservableObject, TrackPlayerProtocol {
    static let shared = TrackPlayer()

    @Published private(set) var playbackState: PlaybackState = .idle
    @Published var repeatState: RepeatState = .repeatOff
    @Published private(set) var bufferedTime: TimeInterval = 0
    @Published private(set) var currentTrack: MusicTrack? = nil

    private var player: AVPlayer?
    private var timeObserver: Any?
    private var playerItemObserver: NSKeyValueObservation?
    private var rateObserver: NSKeyValueObservation?
    private var loadedTimeRangesObserver: NSKeyValueObservation?
    private var cancellables = Set<AnyCancellable>()

    // Internal state tracking
    private var internalCurrentTime: TimeInterval = 0
    private var internalDuration: TimeInterval = 0

    private let trackLoader = TrackLoader.shared

    // MARK: - TrackPlayerProtocol Conformance

    var isPlaying: Bool {
        playbackState.isPlaying
    }

    var currentTime: TimeInterval {
        playbackState.currentTime ?? 0
    }

    private init() {
        setupAudioSession()
    }

    // MARK: - Public Methods

    /// Load a track without playing it
    /// - Parameter track: The track to load
    func loadTrack(_ track: MusicTrack) async {
        // Stop current playback if any
        if playbackState.currentTrackId != nil {
            stop()
        }

        currentTrack = track
        playbackState = .loading(trackId: track.id)

        do {
            // Get or load the asset
            var asset = trackLoader.getAsset(for: track.id)

            if asset == nil, let url = track.previewURL {
                try await trackLoader.loadTrack(trackId: track.id, from: url)
                asset = trackLoader.getAsset(for: track.id)
            }

            guard let unwrappedAsset = asset else {
                playbackState = .failed(error: .assetNotFound(trackId: track.id))
                return
            }

            // Create player item and player
            let playerItem = AVPlayerItem(asset: unwrappedAsset)
            let player = AVPlayer(playerItem: playerItem)
            self.player = player

            // Get duration from the player item instead
            internalDuration = CMTimeGetSeconds(playerItem.duration)

            // Set up observers
            setupPlayerObservers(for: playerItem)

            // Set to paused state (loaded but not playing)
            internalCurrentTime = 0
            playbackState = .paused(
                trackId: track.id, currentTime: internalCurrentTime, duration: internalDuration)

            print("Loaded track \(track.id) without playing")
        } catch {
            print("Error loading track: \(error)")
            playbackState = .failed(error: .loadFailed(trackId: track.id, underlyingError: error))
        }
    }

    /// Play a track
    /// - Parameter track: The track to play
    func play(track: MusicTrack) async {
        // If same track is paused, just resume
        if case .paused(let pausedTrackId, _, _) = playbackState, pausedTrackId == track.id {
            resume()
            return
        }

        // If same track is already loaded, just play it
        if currentTrack?.id == track.id && player != nil {
            player?.play()
            playbackState = .playing(
                trackId: track.id, currentTime: internalCurrentTime, duration: internalDuration)
            print("Resumed playing track \(track.id)")
            return
        }

        // Stop current playback if any
        if playbackState.currentTrackId != nil {
            stop()
        }

        currentTrack = track
        playbackState = .loading(trackId: track.id)

        do {
            // Get or load the asset
            var asset = trackLoader.getAsset(for: track.id)

            if asset == nil, let url = track.previewURL {
                try await trackLoader.loadTrack(trackId: track.id, from: url)
                asset = trackLoader.getAsset(for: track.id)
            }

            guard let unwrappedAsset = asset else {
                playbackState = .failed(error: .assetNotFound(trackId: track.id))
                return
            }

            // Create player item and player
            let playerItem = AVPlayerItem(asset: unwrappedAsset)
            let player = AVPlayer(playerItem: playerItem)
            self.player = player

            // Get duration from the player item instead
            internalDuration = CMTimeGetSeconds(playerItem.duration)

            // Set up observers
            setupPlayerObservers(for: playerItem)

            // Start playback
            player.play()
            internalCurrentTime = 0
            playbackState = .playing(
                trackId: track.id, currentTime: internalCurrentTime, duration: internalDuration)

            print("Started playing track \(track.id)")
        } catch {
            print("Error playing track: \(error)")
            playbackState = .failed(error: .loadFailed(trackId: track.id, underlyingError: error))
        }
    }

    /// Pause the current playback
    func pause() {
        guard let trackId = playbackState.currentTrackId, playbackState.isPlaying else {
            return
        }

        player?.pause()
        playbackState = .paused(
            trackId: trackId, currentTime: internalCurrentTime, duration: internalDuration)
        print("Paused track \(trackId)")
    }

    /// Resume playback if paused
    func resume() {
        guard let trackId = playbackState.currentTrackId, playbackState.isPaused else {
            return
        }

        player?.play()
        playbackState = .playing(
            trackId: trackId, currentTime: internalCurrentTime, duration: internalDuration)
        print("Resumed track \(trackId)")
    }

    /// Stop playback completely
    func stop() {
        guard let trackId = playbackState.currentTrackId else {
            return
        }

        player?.pause()
        player?.seek(to: .zero)
        removePlayerObservers()

        player = nil
        currentTrack = nil
        internalCurrentTime = 0
        internalDuration = 0
        bufferedTime = 0
        playbackState = .idle

        print("Stopped track \(trackId)")
    }

    /// Seek to a specific time in the current track
    /// - Parameter time: Time in seconds
    func seek(to time: TimeInterval) {
        guard let trackId = playbackState.currentTrackId else {
            return
        }

        let cmTime = CMTime(seconds: time, preferredTimescale: 600)
        player?.seek(to: cmTime, toleranceBefore: .zero, toleranceAfter: .zero)
        internalCurrentTime = time

        // Update state with new time
        if playbackState.isPlaying {
            playbackState = .playing(
                trackId: trackId, currentTime: internalCurrentTime, duration: internalDuration)
        } else if playbackState.isPaused {
            playbackState = .paused(
                trackId: trackId, currentTime: internalCurrentTime, duration: internalDuration)
        }
    }

    /// Toggle between play and pause
    func togglePlayPause() {
        if playbackState.isPlaying {
            pause()
        } else if playbackState.isPaused {
            resume()
        }
    }

    // MARK: - Private Methods

    private func setupAudioSession() {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playback, mode: .default)
            try audioSession.setActive(true)
            print("Audio session configured successfully")
        } catch {
            print("Failed to set up audio session: \(error)")
        }
    }

    private func setupPlayerObservers(for playerItem: AVPlayerItem) {
        removePlayerObservers()

        // Observe playback time
        let interval = CMTime(seconds: 0.1, preferredTimescale: 600)
        timeObserver = player?.addPeriodicTimeObserver(forInterval: interval, queue: .main) {
            [weak self] time in
            Task { @MainActor [weak self] in
                guard let self = self else { return }
                self.internalCurrentTime = time.seconds

                // Update playback state with new time
                if case .playing(let trackId, _, let duration) = self.playbackState {
                    self.playbackState = .playing(
                        trackId: trackId, currentTime: self.internalCurrentTime, duration: duration)
                }
            }
        }

        // Observe player item status
        playerItemObserver = playerItem.observe(\.status, options: [.new]) { [weak self] item, _ in
            Task { @MainActor [weak self] in
                guard let self = self else { return }

                switch item.status {
                case .failed:
                    if let error = item.error {
                        self.playbackState = .failed(error: .playbackFailed(underlyingError: error))
                        print("Player item failed: \(error)")
                    }
                case .readyToPlay:
                    print("Player item ready to play")
                case .unknown:
                    print("Player item status unknown")
                @unknown default:
                    break
                }
            }
        }

        // Observe when playback reaches end
        NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: playerItem,
            queue: .main
        ) { [weak self] _ in
            Task { @MainActor [weak self] in
                self?.handlePlaybackEnd()
            }
        }

        // Observe buffered time ranges
        loadedTimeRangesObserver = playerItem.observe(\.loadedTimeRanges, options: [.new]) {
            [weak self] item, _ in
            Task { @MainActor [weak self] in
                guard let self = self else { return }

                // Get the buffered time from loadedTimeRanges
                if let timeRange = item.loadedTimeRanges.first?.timeRangeValue {
                    let bufferedSeconds =
                        CMTimeGetSeconds(timeRange.start) + CMTimeGetSeconds(timeRange.duration)
                    self.bufferedTime = bufferedSeconds
                }
            }
        }
    }

    private func removePlayerObservers() {
        if let timeObserver = timeObserver {
            player?.removeTimeObserver(timeObserver)
            self.timeObserver = nil
        }

        playerItemObserver?.invalidate()
        playerItemObserver = nil

        rateObserver?.invalidate()
        rateObserver = nil

        loadedTimeRangesObserver?.invalidate()
        loadedTimeRangesObserver = nil

        NotificationCenter.default.removeObserver(self)
    }

    private func handlePlaybackEnd() {
        print("Playback ended")

        // Check repeat state first
        if repeatState == .repeatOne {
            // Repeat the current track
            player?.seek(to: .zero)
            player?.play()
            internalCurrentTime = 0
            if let trackId = playbackState.currentTrackId {
                playbackState = .playing(
                    trackId: trackId,
                    currentTime: internalCurrentTime,
                    duration: internalDuration
                )
            }
            print("Repeating track")
            return
        }

        // Check if we're near the actual track duration
        // Preview URLs are typically 30 seconds, but actual tracks can be 3+ minutes
        if let track = currentTrack,
           let actualDuration = track.durationSeconds {
            let threshold: TimeInterval = 1.0 // Within 1 second of actual end

            if internalCurrentTime >= actualDuration - threshold {
                // We're at the actual end of the track, clear everything
                stop()
            } else {
                // Preview ended but track isn't over, pause at the end of preview
                guard let trackId = playbackState.currentTrackId else { return }
                player?.pause()
                playbackState = .paused(
                    trackId: trackId,
                    currentTime: internalCurrentTime,
                    duration: internalDuration
                )
                print("Preview ended at \(internalCurrentTime)s, but track is \(actualDuration)s - pausing")
            }
        } else {
            // No actual duration info, just stop as before
            stop()
        }
    }

    deinit {
        // Note: Cannot call main actor isolated methods from deinit
        // Observers will be cleaned up when the player is deallocated
    }
}
