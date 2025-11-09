//
//  TimelineSlider.swift
//  MusicPlayer
//
//  Created by Winston Du on 11/4/25.
//
import SwiftUI

// MARK: - TimelineSlider (TimeInterval Wrapper)

struct TimelineSlider<Knob: View>: View {
    @Binding var currentTime: TimeInterval
    let bufferedTime: TimeInterval

    let duration: TimeInterval

    let trackColor: Color
    let bufferedColor: Color
    let progressColor: Color
    let trackHeight: CGFloat

    let knob: Knob

    // Callbacks for interaction events
    var onInteractionStart: (@MainActor () -> Void)?
    var onInteractionEnd: (@MainActor () -> Void)?

    init(
        currentTime: Binding<TimeInterval>,
        bufferedTime: TimeInterval,
        duration: TimeInterval,
        trackColor: Color = Colors.TimelineColors.barUnplayed,
        bufferedColor: Color = Colors.TimelineColors.barLoaded,
        progressColor: Color = Colors.TimelineColors.barPlayed,
        trackHeight: CGFloat = 3,
        onInteractionStart: (@MainActor () -> Void)? = nil,
        onInteractionEnd: (@MainActor () -> Void)? = nil,
        @ViewBuilder knob: () -> Knob
    ) {
        self._currentTime = currentTime
        self.bufferedTime = bufferedTime
        self.duration = duration
        self.trackColor = trackColor
        self.bufferedColor = bufferedColor
        self.progressColor = progressColor
        self.trackHeight = trackHeight
        self.onInteractionStart = onInteractionStart
        self.onInteractionEnd = onInteractionEnd
        self.knob = knob()
    }

    var body: some View {
        VStack(spacing: 3) {
            ProgressSlider(
                knobPosition: $currentTime,
                bufferedPosition: bufferedTime,
                start: 0,
                end: duration,
                trackColor: trackColor,
                bufferedColor: bufferedColor,
                progressColor: progressColor,
                trackHeight: trackHeight,
                onInteractionStart: onInteractionStart,
                onInteractionEnd: onInteractionEnd
            ) {
                knob
            }
            .fixedSize(horizontal: false, vertical: true)
            .frame(maxHeight: 16)

            HStack {
                Text(formatTime(currentTime))
                    .foregroundColor(Color.white.opacity(0.7))
                    .font(Fonts.Medium.size(12))

                Spacer()

                Text(formatTime(duration))
                    .foregroundColor(Color.white.opacity(0.7))
                    .font(Fonts.Medium.size(12))
            }
        }
    }

    private func formatTime(_ time: TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = (Int(time) % 3600) / 60
        let seconds = Int(time) % 60

        if hours > 0 {
            return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        } else {
            return String(format: "%d:%02d", minutes, seconds)
        }
    }
}

// Extension to provide a convenience init with default knob
extension TimelineSlider where Knob == AnyView {
    init(
        currentTime: Binding<TimeInterval>,
        bufferedTime: TimeInterval,
        duration: TimeInterval,
        trackColor: Color = Colors.TimelineColors.barUnplayed,
        bufferedColor: Color = Colors.TimelineColors.barLoaded,
        progressColor: Color = Colors.TimelineColors.barPlayed,
        trackHeight: CGFloat = 3
    ) {
        self.init(
            currentTime: currentTime,
            bufferedTime: bufferedTime,
            duration: duration,
            trackColor: trackColor,
            bufferedColor: bufferedColor,
            progressColor: progressColor,
            trackHeight: trackHeight
        ) {
            AnyView(
                Circle()
                    .foregroundColor(.white)
                    .frame(width: 24, height: 24)
            )
        }
    }
}

// MARK: - Previews

#Preview("TimelineSlider") {
    @Previewable @State var currentTime: TimeInterval = 125  // 2:05
    @Previewable @State var bufferedTime: TimeInterval = 180  // 3:00
    let duration: TimeInterval = 300  // 5:00

    TimelineSlider(
        currentTime: $currentTime,
        bufferedTime: bufferedTime,
        duration: duration
    )
    .padding()
    .background(Colors.background)
}
