//
//  ContentView.swift
//  MusicPlayer
//
//  Created by Winston Du on 11/4/25.
//

import SwiftUI

struct ContentView: View {

    // Debug toggle
    @State private var hasTrack: Bool = true

    // Persistent favorites dictionary (trackId -> isFavorite)
    @State private var favorites: [String: Bool] = [:]

    // AudioWidget state
    @State private var currentTrack: MusicTrack?
    @State private var isPlaying: Bool = false
    @State private var isFavorite: Bool = false
    @State private var repeatState: RepeatState = .repeatOff
    @State private var currentTime: TimeInterval = 0
    @State private var bufferedTime: TimeInterval = 60

    let sampleTrack = MusicTrack(
        id: "1",
        name: "Black Friday",
        artist: "Lost Frequencies, Tom Odell, Poppy Baskcomb",
        previewURL: nil,
        artworkUrl100: URL(
            string:
                "https://lh3.googleusercontent.com/gShVRyvLLbwVB8jeIPghCXgr96wxTHaM4zqfmxIWRsUpMhMn38PwuUU13o1mXQzLMt5HFqX761u8Tgo4L_JG1XLATvw=s0"
        )
    )

    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()

            VStack(spacing: 20) {
                // Debug toggle
                Toggle("Has Track", isOn: $hasTrack)
                    .padding()
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(8)
                    .padding(.horizontal, 40)
                    .onChange(of: hasTrack) { oldValue, newValue in
                        // Update track when toggle changes
                        currentTrack = newValue ? sampleTrack : nil
                        // Reset state when track is removed
                        if !newValue {
                            currentTime = 0
                            bufferedTime = 0
                        } else {
                            bufferedTime = 60
                        }
                    }

                AudioWidget(
                    currentTrack: $currentTrack,
                    isPlaying: $isPlaying,
                    isFavorite: $isFavorite,
                    repeatState: $repeatState,
                    currentTime: $currentTime,
                    bufferedTime: $bufferedTime
                )
            }
        }
        .onAppear {
            // Initialize with sample track
            currentTrack = hasTrack ? sampleTrack : nil
        }
        .onChange(of: currentTrack) { oldValue, newValue in
            if let newTrack = newValue {
                // Load favorite state from dictionary
                isFavorite = favorites[newTrack.id] ?? false
            } else {
                // No track loaded
                isFavorite = false
                isPlaying = false
            }
        }
        .onChange(of: isFavorite) { oldValue, newValue in
            if let track = currentTrack {
                favorites[track.id] = newValue
            }
        }
    }
}

#Preview {
    ContentView()
}
