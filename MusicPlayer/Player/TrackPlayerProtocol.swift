//
//  TrackPlayerProtocol.swift
//  MusicPlayer
//
//  Created by Winston Du on 11/9/25.
//

import AVFoundation
import Combine
import Foundation
import SwiftUI

/// Protocol defining observable track player properties
protocol TrackPlayerProtocol: AnyObject, ObservableObject {
    var currentTrack: MusicTrack? { get }
    var isPlaying: Bool { get }
    var repeatState: RepeatState { get set }
    var currentTime: TimeInterval { get }
    var bufferedTime: TimeInterval { get }

    /// Toggle between play and pause
    func togglePlayPause()

    // Controls needed for scrubbing/slider interaction
    func pause()
    func resume()
    func seek(to time: TimeInterval)
}

// Extension providing binding helper for writable properties
extension TrackPlayerProtocol {
    /// Creates a Binding for a writable property using KeyPath
    func binding<T>(for keyPath: ReferenceWritableKeyPath<Self, T>) -> Binding<T> {
        Binding(
            get: { self[keyPath: keyPath] },
            set: { self[keyPath: keyPath] = $0 }
        )
    }
}
