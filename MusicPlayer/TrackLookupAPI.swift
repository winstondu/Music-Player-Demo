//
//  TrackLookupAPI.swift
//  MusicPlayer
//
//  Created by Winston Du on 11/4/25.
//

import Foundation

// iTunes Search API Response structures
private struct iTunesSearchResponse: Codable {
    let resultCount: Int
    let results: [iTunesSong]
}

private struct iTunesSong: Codable {
    let trackId: Int
    let trackName: String
    let artistName: String
    let previewUrl: String?
    let artworkUrl100: String?
    let trackTimeMillis: Int?
}

class TrackLookupAPI {
    static let shared = TrackLookupAPI()

    private init() {}

    /// Search for tracks using the iTunes Search API
    /// - Parameter query: The search query string
    /// - Returns: Array of MusicTrack results
    func searchTracks(query: String) async -> [MusicTrack] {
        guard !query.isEmpty else { return [] }

        do {
            // Use iTunes Search API (free, no registration needed)
            let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            let urlString = "https://itunes.apple.com/search?term=\(encodedQuery)&media=music&entity=song&limit=10"

            guard let url = URL(string: urlString) else { return [] }

            let (data, _) = try await URLSession.shared.data(from: url)
            let searchResponse = try JSONDecoder().decode(iTunesSearchResponse.self, from: data)

            print("iTunes API returned \(searchResponse.results.count) songs")

            let tracks = searchResponse.results.map { song -> MusicTrack in
                let hasPreview = song.previewUrl != nil
                print("Song: \(song.trackName) by \(song.artistName) - Preview: \(hasPreview ? "✅" : "❌")")

                return MusicTrack(
                    id: "\(song.trackId)",
                    name: song.trackName,
                    artist: song.artistName,
                    previewURL: song.previewUrl != nil ? URL(string: song.previewUrl!) : nil,
                    artworkUrl100: song.artworkUrl100 != nil ? URL(string: song.artworkUrl100!) : nil,
                    trackTimeMillis: song.trackTimeMillis
                )
            }

            let tracksWithPreviews = tracks.filter { $0.previewURL != nil }
            print("Returning \(tracks.count) tracks (\(tracksWithPreviews.count) with previews)")

            return tracks
        } catch {
            print("Error searching iTunes: \(error)")
            return []
        }
    }

    /// Look up track details by track ID
    /// - Parameter trackId: The iTunes track ID
    /// - Returns: MusicTrack if found, nil otherwise
    func lookupTrack(trackId: String) async -> MusicTrack? {
        guard let id = Int(trackId) else { return nil }

        do {
            let urlString = "https://itunes.apple.com/lookup?id=\(id)"
            guard let url = URL(string: urlString) else { return nil }

            let (data, _) = try await URLSession.shared.data(from: url)
            let searchResponse = try JSONDecoder().decode(iTunesSearchResponse.self, from: data)

            guard let song = searchResponse.results.first else { return nil }

            return MusicTrack(
                id: "\(song.trackId)",
                name: song.trackName,
                artist: song.artistName,
                previewURL: song.previewUrl != nil ? URL(string: song.previewUrl!) : nil,
                artworkUrl100: song.artworkUrl100 != nil ? URL(string: song.artworkUrl100!) : nil,
                trackTimeMillis: song.trackTimeMillis
            )
        } catch {
            print("Error looking up track: \(error)")
            return nil
        }
    }
}
