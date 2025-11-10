//
//  TrackDisplayView.swift
//  MusicPlayer
//
//  Created by Winston Du on 11/4/25.
//

import SwiftUI

struct TrackDisplayView: View {
    let track: MusicTrack?
    let artworkSize: CGFloat

    init(track: MusicTrack?, artworkSize: CGFloat = 88) {
        self.track = track
        self.artworkSize = artworkSize
    }

    var body: some View {
        HStack(spacing: 16) {
            // Album artwork
            if let track = track {
                AsyncImage(url: track.artworkUrl100) { phase in
                    switch phase {
                    case .empty:
                        placeholderArtwork
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: artworkSize, height: artworkSize)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    case .failure:
                        placeholderArtwork
                    @unknown default:
                        placeholderArtwork
                    }
                }
                .frame(width: artworkSize, height: artworkSize)
                .cornerRadius(4)
            } else {
                placeholderArtwork
            }

            VStack(alignment: .leading, spacing: 0) {
                // Track name with marquee (weight 500)
                MarqueeText(
                    text: track?.name ?? "No Track",
                    font: Fonts.Medium.size(24)
                )
                .fontWeight(.medium)
                .foregroundColor(Color.white)
                .frame(height: 32)

                Color.clear.frame(height: 10)

                // Artist name with ellipsis
                Text(track?.artist ?? "Select a track to play")
                    .font(Fonts.Regular.size(16))
                    .foregroundColor(Color.white)
                    .opacity(0.5)
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .frame(height: 24)
            }
        }
    }

    private var placeholderArtwork: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(Color.gray.opacity(0.3))
            .frame(width: artworkSize, height: artworkSize)
            .overlay(
                Image(systemName: "music.note")
                    .font(.system(size: artworkSize / 3))
                    .foregroundColor(.white.opacity(0.5))
            )
    }
}

#Preview {
    ZStack {
        Colors.background
            .ignoresSafeArea()

        TrackDisplayView(
            track: MusicTrack.defaultMusicTrack,
            artworkSize: 88
        )
    }
}
