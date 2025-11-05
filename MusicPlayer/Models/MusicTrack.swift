//
//  MusicTrack.swift
//  MusicPlayer
//
//  Created by Winston Du on 11/5/25.
//

import Foundation

struct MusicTrack: Identifiable, Codable {
    let id: String
    let name: String
    let artist: String
    let previewURL: URL?
    let artworkUrl100: URL?
}
