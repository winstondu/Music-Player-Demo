//
//  SkipIcon.swift
//  MusicPlayer
//
//  Created by Winston Du on 11/4/25.
//

import SwiftUI

struct SkipIcon: View {
    public enum SkipDirection {
        case left
        case right
    }

    let direction: SkipIcon.SkipDirection

    let size: CGFloat
    
    let frameSize: CGFloat

    let foregroundColor: Color = Colors.surfaceColor

    var body: some View {
        Image(directionIcon, bundle: .main)
            .font(.system(size: size))
            .fontWeight(.light)
            .foregroundStyle(foregroundColor)
            .frame(width: frameSize, height: frameSize)
    }

    var directionIcon: String {
        switch direction {
        case .left:
            "skip_previous"
        case .right:
            "skip_next"
        }
    }
}
