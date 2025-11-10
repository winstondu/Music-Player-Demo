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
    
    
    static let defaultMusicTrack = MusicTrack(
        id: "1",
        name: "Black Friday (pretty like the sun)",
        artist: "Lost Frequencies, Tom Odell, Poppy Baskcomb",
        previewURL: nil,
        artworkUrl100: URL(string: "https://lh3.googleusercontent.com/gShVRyvLLbwVB8jeIPghCXgr96wxTHaM4zqfmxIWRsUpMhMn38PwuUU13o1mXQzLMt5HFqX761u8Tgo4L_JG1XLATvw=s0")!,
        trackTimeMillis: 300000,
    )
}
