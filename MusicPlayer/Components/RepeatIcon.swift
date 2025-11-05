//
//  RepeatIcon.swift
//  MusicPlayer
//
//  Created by Winston Du on 11/4/25.
//
import SwiftUI

enum RepeatState: CaseIterable {
    case repeatOff
    case repeatOn
    case repeatOne

    mutating func toggle() {
        switch self {
        case .repeatOff:
            self = .repeatOn
        case .repeatOn:
            self = .repeatOne
        case .repeatOne:
            self = .repeatOff
        }
    }

    var iconName: String {
        switch self {
        case .repeatOff:
            return "repeat"
        case .repeatOn:
            return "repeat"
        case .repeatOne:
            return "repeat_one"
        }
    }

    var tintColor: Color {
        switch self {
        case .repeatOff:
            return Colors.surfaceColor
        case .repeatOn, .repeatOne:
            return Colors.successContainerColor
        }
    }
}

struct RepeatIcon: View {
    @Binding var repeatState: RepeatState

    let size: CGFloat

    let frameSize: CGFloat

    var body: some View {
        Image(repeatState.iconName, bundle: .main)
            .font(.system(size: size))
            .fontWeight(.light)
            .foregroundStyle(repeatState.tintColor)
            .frame(width: frameSize, height: frameSize)
            .releaseAction {
                repeatState.toggle()
            }
    }
}

// MARK: - Standalone Preview Version

struct RepeatIconStandalone: View {
    @State private var repeatState: RepeatState
    var size: CGFloat = 24
    var frameSize: CGFloat = 36

    var body: some View {
        RepeatIcon(repeatState: $repeatState, size: size, frameSize: frameSize)
    }

    init(repeatState: RepeatState = .repeatOff, size: CGFloat = 24, frameSize: CGFloat = 36) {
        self._repeatState = State(initialValue: repeatState)
        self.size = size
        self.frameSize = frameSize
    }
}

// MARK: - Previews

#Preview("Repeat") {
    RepeatIconStandalone(repeatState: .repeatOff, size: 24, frameSize: 48)
        .padding()
        .background(Color.gray.opacity(0.3))
}
