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
        id: "1755039408",
        name: "Black Friday (pretty like the sun)",
        artist: "Lost Frequencies, Tom Odell, Poppy Baskcomb",
        previewURL: URL(
            string:
                "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview211/v4/b2/4a/44/b24a448f-cdb5-f532-6596-753226e0dddc/mzaf_14325479291657353731.plus.aac.p.m4a"
        ),
        artworkUrl100: URL(
            string:
                "https://is1-ssl.mzstatic.com/image/thumb/Music221/v4/39/a7/49/39a749b9-f198-58ea-2198-a214d6c168b7/00198704029172_Cover.jpg/100x100bb.jpg"
        ),
        trackTimeMillis: 30000
    )
}
