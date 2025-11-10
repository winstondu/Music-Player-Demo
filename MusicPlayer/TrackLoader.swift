//
//  TrackLoader.swift
//  MusicPlayer
//
//  Created by Winston Du on 11/4/25.
//

import Foundation
@preconcurrency import AVFoundation
import Combine

/// Represents the loading state of a track
@MainActor
class TrackLoadState: ObservableObject {
    let trackId: String
    let asset: AVAsset?

    @Published var duration: CMTime
    @Published var loadedTimeRanges: [CMTimeRange]
    @Published var isFullyLoaded: Bool

    var totalDuration: TimeInterval {
        duration.seconds
    }

    var loadedDuration: TimeInterval {
        loadedTimeRanges.reduce(0.0) { total, range in
            total + range.duration.seconds
        }
    }

    var loadProgress: Double {
        guard totalDuration > 0 else { return 0.0 }
        return loadedDuration / totalDuration
    }

    init(trackId: String, asset: AVAsset?, duration: CMTime, loadedTimeRanges: [CMTimeRange], isFullyLoaded: Bool) {
        self.trackId = trackId
        self.asset = asset
        self.duration = duration
        self.loadedTimeRanges = loadedTimeRanges
        self.isFullyLoaded = isFullyLoaded
    }
}

@MainActor
class TrackLoader: ObservableObject {
    static let shared = TrackLoader()

    // Cache of loaded assets by track ID
    @Published private(set) var loadedTracks: [String: AVAsset] = [:]
    @Published private(set) var loadStates: [String: TrackLoadState] = [:]

    private var playerItems: [String: AVPlayerItem] = [:]
    private var observers: [String: Any] = [:]
    private var cancellables = Set<AnyCancellable>()

    private init() {}

    /// Load a track from a remote URL
    /// - Parameters:
    ///   - trackId: Unique identifier for the track
    ///   - url: Remote URL of the audio file
    func loadTrack(trackId: String, from url: URL) async throws {
        // Check if already loaded
        if loadedTracks[trackId] != nil {
            print("Track \(trackId) already loaded")
            return
        }

        print("Loading track \(trackId) from \(url)")

        // Create asset with caching enabled
        let asset = AVURLAsset(url: url, options: [
            AVURLAssetPreferPreciseDurationAndTimingKey: true
        ])

        // Load essential properties asynchronously
        let duration = try await asset.load(.duration)

        // Create player item to track loading progress
        let playerItem = AVPlayerItem(asset: asset)
        playerItems[trackId] = playerItem
        loadedTracks[trackId] = asset

        // Initial state
        updateLoadState(trackId: trackId, asset: asset, duration: duration, playerItem: playerItem)

        // Observe loading progress
        startObservingLoadProgress(trackId: trackId, playerItem: playerItem, duration: duration, asset: asset)
    }

    /// Get the current load state for a track
    /// - Parameter trackId: The track identifier
    /// - Returns: TrackLoadState if the track is being loaded, nil otherwise
    func getLoadState(for trackId: String) -> TrackLoadState? {
        return loadStates[trackId]
    }

    /// Get the loaded asset for a track
    /// - Parameter trackId: The track identifier
    /// - Returns: AVAsset if loaded, nil otherwise
    func getAsset(for trackId: String) -> AVAsset? {
        return loadedTracks[trackId]
    }

    /// Get the total duration of a track
    /// - Parameter trackId: The track identifier
    /// - Returns: Duration in seconds, or 0 if not loaded
    func getDuration(for trackId: String) -> TimeInterval {
        return loadStates[trackId]?.totalDuration ?? 0
    }

    /// Get the loaded duration of a track
    /// - Parameter trackId: The track identifier
    /// - Returns: Loaded duration in seconds, or 0 if not loaded
    func getLoadedDuration(for trackId: String) -> TimeInterval {
        return loadStates[trackId]?.loadedDuration ?? 0
    }

    /// Get the load progress (0.0 to 1.0) for a track
    /// - Parameter trackId: The track identifier
    /// - Returns: Progress percentage, or 0 if not loaded
    func getLoadProgress(for trackId: String) -> Double {
        return loadStates[trackId]?.loadProgress ?? 0
    }

    /// Remove a track from the cache
    /// - Parameter trackId: The track identifier
    func removeTrack(trackId: String) {
        stopObserving(trackId: trackId)
        loadedTracks.removeValue(forKey: trackId)
        loadStates.removeValue(forKey: trackId)
        playerItems.removeValue(forKey: trackId)
    }

    /// Clear all cached tracks
    func clearCache() {
        for trackId in loadedTracks.keys {
            stopObserving(trackId: trackId)
        }
        loadedTracks.removeAll()
        loadStates.removeAll()
        playerItems.removeAll()
    }

    // MARK: - Private Methods

    private func updateLoadState(trackId: String, asset: AVAsset, duration: CMTime, playerItem: AVPlayerItem) {
        let loadedTimeRanges = playerItem.loadedTimeRanges.map { $0.timeRangeValue }
        let isFullyLoaded = !loadedTimeRanges.isEmpty && loadedTimeRanges.first?.end == duration

        // Update existing state or create new one
        if let existingState = loadStates[trackId] {
            existingState.duration = duration
            existingState.loadedTimeRanges = loadedTimeRanges
            existingState.isFullyLoaded = isFullyLoaded
        } else {
            let state = TrackLoadState(
                trackId: trackId,
                asset: asset,
                duration: duration,
                loadedTimeRanges: loadedTimeRanges,
                isFullyLoaded: isFullyLoaded
            )
            loadStates[trackId] = state
        }

        if let state = loadStates[trackId] {
            print("Track \(trackId) - Duration: \(duration.seconds)s, Loaded: \(state.loadedDuration)s (\(Int(state.loadProgress * 100))%)")
        }
    }

    private func startObservingLoadProgress(trackId: String, playerItem: AVPlayerItem, duration: CMTime, asset: AVAsset) {
        // Observe loadedTimeRanges to track loading progress
        let observer = playerItem.observe(\.loadedTimeRanges, options: [.new]) { [weak self] item, _ in
            Task { @MainActor [weak self] in
                self?.updateLoadState(trackId: trackId, asset: asset, duration: duration, playerItem: item)
            }
        }

        observers[trackId] = observer
    }

    private func stopObserving(trackId: String) {
        if let observer = observers[trackId] as? NSKeyValueObservation {
            observer.invalidate()
        }
        observers.removeValue(forKey: trackId)
    }
}
