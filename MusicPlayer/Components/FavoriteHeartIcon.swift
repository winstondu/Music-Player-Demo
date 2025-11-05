//
//  FavoriteHeartIcon.swift
//  MusicPlayer
//
//  Created by Winston Du on 11/4/25.
//

import Lottie
import SwiftUI

private class FavoritingAnimation {
    static let animation = LottieAnimation.filepath(
        Bundle.main.path(forResource: "Burst", ofType: "json")!)!

    static let favoritingStart = 0.1  // This is the unfavorited state
    static let favoritingEnd = 1.0  // This is the favorited state
}

struct FavoriteHeartIcon: View {
    @Binding var isFavorite: Bool

    @State private var isAnimating = false

    let heartSize: CGFloat

    let frameSize: CGFloat

    let foregroundColor: Color = Colors.surfaceColor

    var body: some View {
        ZStack {
            // Unfavorite state - static SVG
            Image("favorite", bundle: .main)
                .font(.system(size: heartSize))
                .fontWeight(.light)
                .foregroundStyle(foregroundColor)
                .opacity(!isFavorite ? 1 : 0)

            // Favorite state - filled SVG
            Image("favorite_fill", bundle: .main)
                .font(.system(size: heartSize))
                .fontWeight(.light)
                .foregroundStyle(Colors.HeartColor.heartFilled)
                .opacity(isFavorite ? 1 : 0)
        }
        .frame(width: frameSize, height: frameSize)
        .overlay(alignment: .center) {
            // Lottie burst during favoriting transition (false -> true)
            LottieView(animation: FavoritingAnimation.animation)
                .playbackMode(
                    isAnimating
                        ? .playing(
                            .fromProgress(
                                FavoritingAnimation.favoritingStart,
                                toProgress: FavoritingAnimation.favoritingEnd, loopMode: .playOnce))
                        : .paused(at: .progress(FavoritingAnimation.favoritingStart))
                )
                .animationDidFinish { completed in
                    isAnimating = false
                }
                .frame(width: frameSize * 1.5, height: frameSize * 1.5)
                .opacity(isAnimating ? 1 : 0)
        }
        .contentShape(Rectangle())
        .releaseAction {
            toggleFavorite()
        }
        .onChange(of: isFavorite) { oldValue, newValue in
            if newValue && !oldValue {
                // Only animate on false -> true transition
                isAnimating = true
            }
        }
    }

    private func toggleFavorite() {
        isFavorite.toggle()
    }
}

// Standalone version with internal state
struct FavoriteHeartIconStandalone: View {
    @State private var isFavorite: Bool
    var frameSize: CGFloat = 36

    var body: some View {
        FavoriteHeartIcon(isFavorite: $isFavorite, heartSize: 24, frameSize: frameSize)
    }

    init(isFavorite favorited: Bool, frameSize: CGFloat) {
        self.isFavorite = favorited
        self.frameSize = frameSize
    }
}

#Preview("Not Favorited") {
    FavoriteHeartIconStandalone(isFavorite: false, frameSize: 48)
        .padding()
        .background(Color.gray.opacity(0.3))
}
