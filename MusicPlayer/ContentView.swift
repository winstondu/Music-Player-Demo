//
//  ContentView.swift
//  MusicPlayer
//
//  Created by Winston Du on 11/4/25.
//

import SwiftUI

struct ContentView: View {
    
    let musicTrack = MusicTrack(
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
            AudioWidget(currentTrack: musicTrack, isPlaying: false, isFavorite: false)
        }
    }
}

#Preview {
    ContentView()
}
