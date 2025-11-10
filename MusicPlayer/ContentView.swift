//
//  ContentView.swift
//  MusicPlayer
//
//  Created by Winston Du on 11/4/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var mockPlayer = MockTrackPlayer()
    private let userPreferences = UserPreferences.shared

    // Debug toggle
    @State private var hasTrack: Bool = true
    @State private var showDebugSidebar: Bool = true

    let sampleTrack = MusicTrack(
        id: "1",
        name: "Black Friday",
        artist: "Lost Frequencies, Tom Odell, Poppy Baskcomb",
        previewURL: nil,
        artworkUrl100: URL(
            string:
                "https://lh3.googleusercontent.com/gShVRyvLLbwVB8jeIPghCXgr96wxTHaM4zqfmxIWRsUpMhMn38PwuUU13o1mXQzLMt5HFqX761u8Tgo4L_JG1XLATvw=s0"
        ),
        trackTimeMillis: 60000
    )

    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()

            HStack(spacing: 0) {
                // Main content area
                ZStack {
                    AudioWidget(player: mockPlayer, preferences: userPreferences)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)

                // Debug sidebar
                if showDebugSidebar {
                    debugSidebar
                        .transition(.move(edge: .trailing))
                }
            }

            // Sidebar toggle button
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                            showDebugSidebar.toggle()
                        }
                    }) {
                        Image(systemName: showDebugSidebar ? "sidebar.right" : "sidebar.left")
                            .font(.system(size: 20))
                            .foregroundColor(.gray)
                            .padding(12)
                            .background(Color.white.opacity(0.9))
                            .clipShape(Circle())
                            .shadow(radius: 4)
                    }
                    .padding(.trailing, showDebugSidebar ? 260 : 20)
                    .padding(.top, 20)
                }
                Spacer()
            }
        }
        .onAppear {
            // Initialize with sample track if needed
            if hasTrack {
                mockPlayer.setTrack(sampleTrack)
                mockPlayer.play()
            }
        }
    }

    private var debugSidebar: some View {
        VStack(spacing: 20) {
            Text("Debug Controls")
                .font(.headline)
                .foregroundColor(.gray)
                .padding(.top, 20)

            VStack(spacing: 12) {
                Toggle("Has Track", isOn: $hasTrack)
                    .padding()
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(8)
                    .onChange(of: hasTrack) { oldValue, newValue in
                        // Update track when toggle changes
                        if newValue {
                            mockPlayer.setTrack(sampleTrack)
                            mockPlayer.play()
                        } else {
                            mockPlayer.setTrack(nil)
                        }
                    }

                Toggle(
                    "Buffering",
                    isOn: Binding(
                        get: { mockPlayer.isBuffering },
                        set: { newValue in
                            if newValue {
                                mockPlayer.beginBuffering()
                            } else {
                                mockPlayer.stopBuffering()
                            }
                        }
                    )
                )
                .padding()
                .background(Color.white.opacity(0.1))
                .cornerRadius(8)
                .disabled(!hasTrack)

                Button("Buffer a bit") {
                    mockPlayer.bufferMore(seconds: 30)
                }
                .padding()
                .background(Color.blue.opacity(0.7))
                .foregroundColor(.white)
                .cornerRadius(8)
                .disabled(!hasTrack)

                Button("Reset buffering") {
                    mockPlayer.resetBuffering()
                }
                .padding()
                .background(Color.orange.opacity(0.7))
                .foregroundColor(.white)
                .cornerRadius(8)
                .disabled(!hasTrack)
            }
            .padding(.horizontal, 16)

            Spacer()
        }
        .frame(width: 240)
        .background(Color.gray.opacity(0.1))
    }
}

#Preview {
    ContentView()
}
