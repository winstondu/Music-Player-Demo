//
//  ContentView.swift
//  MusicPlayer
//
//  Created by Winston Du on 11/4/25.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject private var realPlayer = TrackPlayer.shared
    @StateObject private var mockPlayer = MockTrackPlayer()
    @State private var wrappedRealPlayer: AnyTrackPlayer?
    @State private var wrappedMockPlayer: AnyTrackPlayer?
    private let userPreferences = UserPreferences.shared

    // Debug toggle
    @State private var hasTrack: Bool = true
    @State private var showDebugSidebar: Bool = false
    @State private var selectedTab: SidebarTab = .debug
    @State private var playerType: PlayerType = .real

    // Search state
    @State private var searchQuery: String = ""
    @State private var searchResults: [MusicTrack] = []
    @State private var isSearching: Bool = false
    @State private var hasLoadedInitialSuggestions: Bool = false

    enum PlayerType: String, CaseIterable {
        case real = "Real Player"
        case mock = "Mock Player"
    }

    enum SidebarTab {
        case debug
        case search
    }

    let sampleTrack = MusicTrack.defaultMusicTrack

    // Computed property to get current player
    private var currentPlayer: any TrackPlayerProtocol {
        switch playerType {
        case .real:
            return realPlayer
        case .mock:
            return mockPlayer
        }
    }

    // Computed property for current wrapped player
    private var currentWrappedPlayer: AnyTrackPlayer? {
        playerType == .real ? wrappedRealPlayer : wrappedMockPlayer
    }

    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()

            HStack(spacing: 0) {
                // Main content area
                ZStack {
                    if let player = currentWrappedPlayer {
                        AudioWidget(player: player, preferences: userPreferences)
                            .id("audio-widget-\(playerType.rawValue)")
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)

                // Debug sidebar
                if showDebugSidebar {
                    debugSidebar
                        .transition(.move(edge: .trailing))
                }
            }
            .clipped()
            .ignoresSafeArea(.all, edges: .trailing)

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
                    .ignoresSafeArea(.all, edges: .trailing)
                    .padding(.trailing, showDebugSidebar ? 300 : 20)
                    .padding(.top, 20)
                }
                Spacer()
            }
        }
        .onAppear {
            // Initialize wrapped players with the actual instances
            if wrappedRealPlayer == nil {
                wrappedRealPlayer = AnyTrackPlayer(realPlayer)
            }
            if wrappedMockPlayer == nil {
                wrappedMockPlayer = AnyTrackPlayer(mockPlayer)
            }

            // Load sample track without playing
            if hasTrack {
                Task {
                    await realPlayer.loadTrack(sampleTrack)
                }
            }
        }
    }

    private var debugSidebar: some View {
        VStack(spacing: 0) {
            // Tab selector
            HStack(spacing: 0) {
                tabButton(title: "Debug", tab: .debug)
                tabButton(title: "Search", tab: .search)
            }
            .padding(.top, 20)
            .padding(.horizontal, 16)

            Divider()
                .padding(.top, 12)

            // Tab content
            ScrollView {
                VStack(spacing: 20) {
                    switch selectedTab {
                    case .debug:
                        debugTabContent
                    case .search:
                        searchTabContent
                    }
                }
                .padding(.top, 20)
            }

            Spacer(minLength: 0)
        }
        .frame(width: 280)
        .background(Color.gray.opacity(0.1))
    }

    private func tabButton(title: String, tab: SidebarTab) -> some View {
        Button(action: {
            selectedTab = tab
        }) {
            Text(title)
                .font(.subheadline)
                .fontWeight(selectedTab == tab ? .semibold : .regular)
                .foregroundColor(selectedTab == tab ? .blue : .gray)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .background(
                    selectedTab == tab
                        ? Color.blue.opacity(0.1)
                        : Color.clear
                )
                .cornerRadius(6)
        }
        .buttonStyle(.plain)
    }

    private var debugTabContent: some View {
        VStack(spacing: 12) {
            // Player type picker
            Picker("Player Type", selection: $playerType) {
                ForEach(PlayerType.allCases, id: \.self) { type in
                    Text(type.rawValue).tag(type)
                }
            }
            .pickerStyle(.segmented)
            .padding()
            .background(Color.white.opacity(0.1))
            .cornerRadius(8)
            .onChange(of: playerType) { oldValue, newValue in
                // Reset state when switching players
                if newValue == .real {
                    mockPlayer.setTrack(nil)
                    if hasTrack {
                        Task {
                            await realPlayer.loadTrack(sampleTrack)
                        }
                    }
                } else {
                    realPlayer.stop()
                    if hasTrack {
                        mockPlayer.setTrack(sampleTrack)
                    }
                }
            }

            Toggle("Has Track", isOn: $hasTrack)
                .padding()
                .background(Color.white.opacity(0.1))
                .cornerRadius(8)
                .onChange(of: hasTrack) { oldValue, newValue in
                    // Update track when toggle changes
                    if newValue {
                        Task {
                            if playerType == .real {
                                await realPlayer.loadTrack(sampleTrack)
                            } else {
                                mockPlayer.setTrack(sampleTrack)
                            }
                        }
                    } else {
                        // Stop/clear on current player
                        if playerType == .real {
                            realPlayer.stop()
                        } else {
                            mockPlayer.setTrack(nil)
                        }
                    }
                }

            // Player state info
            VStack(alignment: .leading, spacing: 8) {
                Text("Player State")
                    .font(.headline)

                if let track = currentPlayer.currentTrack {
                    Text("Playing: \(track.name)")
                        .font(.caption)
                } else {
                    Text("No track loaded")
                        .font(.caption)
                        .foregroundColor(.gray)
                }

                Text("Buffered: \(formatDuration(currentPlayer.bufferedTime))")
                    .font(.caption)

                Text("Status: \(currentPlayer.isPlaying ? "Playing" : "Paused")")
                    .font(.caption)
            }
            .padding()
            .background(Color.white.opacity(0.1))
            .cornerRadius(8)

            // Mock-specific controls
            if playerType == .mock {
                mockPlayerControls
            }
        }
        .padding(.horizontal, 16)
    }

    private var mockPlayerControls: some View {
        VStack(spacing: 12) {
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
                mockPlayer.bufferMore(seconds: 10)
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
    }

    private var searchTabContent: some View {
        VStack(spacing: 16) {
            // Search field
            HStack {
                TextField("Search tracks...", text: $searchQuery)
                    .textFieldStyle(.roundedBorder)
                    .onSubmit {
                        performSearch()
                    }

                if isSearching {
                    ProgressView()
                        .scaleEffect(0.8)
                } else {
                    Button(action: performSearch) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.blue)
                    }
                }
            }

            // Results
            if searchResults.isEmpty && !searchQuery.isEmpty && !isSearching {
                Text("No results found")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding()
            } else {
                VStack(spacing: 8) {
                    ForEach(searchResults) { track in
                        trackResultRow(track)
                    }
                }
            }
        }
        .padding(.horizontal, 16)
        .onAppear {
            loadInitialSuggestions()
        }
    }

    private func trackResultRow(_ track: MusicTrack) -> some View {
        Button(action: {
            Task {
                if playerType == .real {
                    await realPlayer.play(track: track)
                } else {
                    mockPlayer.setTrack(track)
                    mockPlayer.play()
                }
                hasTrack = true
            }
        }) {
            VStack(alignment: .leading, spacing: 4) {
                Text(track.name)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                    .lineLimit(1)

                Text(track.artist)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .lineLimit(1)

                if let duration = track.durationSeconds {
                    Text(formatDuration(duration))
                        .font(.caption2)
                        .foregroundColor(.gray.opacity(0.7))
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(12)
            .background(Color.white.opacity(0.5))
            .cornerRadius(8)
        }
        .buttonStyle(.plain)
    }

    private func loadInitialSuggestions() {
        guard !hasLoadedInitialSuggestions else { return }

        hasLoadedInitialSuggestions = true

        // Use hardcoded tracks from Taylor Swift's 1989 album (fetched via iTunes API)
        searchResults = taylorSwift1989Tracks
    }

    private func performSearch() {
        guard !searchQuery.isEmpty else { return }

        isSearching = true
        Task {
            let results = await TrackLookupAPI.shared.searchTracks(query: searchQuery)
            await MainActor.run {
                searchResults = results
                isSearching = false
            }
        }
    }

    private func formatDuration(_ seconds: TimeInterval) -> String {
        let minutes = Int(seconds) / 60
        let secs = Int(seconds) % 60
        return String(format: "%d:%02d", minutes, secs)
    }
}

#Preview {
    ContentView()
}
