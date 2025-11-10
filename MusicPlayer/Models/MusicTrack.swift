//
//  MusicTrack.swift
//  MusicPlayer
//
//  Created by Winston Du on 11/5/25.
//

import Foundation

struct MusicTrack: Identifiable, Codable, Equatable {
    let id: String
    let name: String
    let artist: String
    let previewURL: URL?
    let artworkUrl100: URL?
    let trackTimeMillis: Int?

    var durationSeconds: TimeInterval? {
        guard let millis = trackTimeMillis else { return nil }
        return TimeInterval(millis) / 1000.0
    }
}
