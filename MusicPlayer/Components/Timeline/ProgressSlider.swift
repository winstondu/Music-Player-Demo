//
//  ProgressSlider.swift
//  MusicPlayer
//
//  Created by Winston Du on 11/4/25.
//
import SwiftUI

struct ProgressSlider<Knob: View>: View {
    @State private var didBeginInteraction: Bool = false
    @Binding var knobPosition: Double
    let bufferedPosition: Double

    let start: Double
    let end: Double

    // Customizable colors for the progress bar rectangles
    let trackColor: Color
    let bufferedColor: Color
    let progressColor: Color

    let trackHeight: CGFloat
    private let cornerRadius: CGFloat = 2

    let knob: Knob

    // Callbacks for interaction events
    var onInteractionStart: (@MainActor () -> Void)?
    var onInteractionEnd: (@MainActor () -> Void)?

    init(
        knobPosition: Binding<Double>,
        bufferedPosition: Double,
        start: Double,
        end: Double,
        trackColor: Color = Colors.TimelineColors.barUnplayed,
        bufferedColor: Color = Colors.TimelineColors.barLoaded,
        progressColor: Color = Colors.TimelineColors.barPlayed,
        trackHeight: CGFloat = 3,
        onInteractionStart: (@MainActor () -> Void)? = nil,
        onInteractionEnd: (@MainActor () -> Void)? = nil,
        @ViewBuilder knob: () -> Knob
    ) {
        self._knobPosition = knobPosition
        self.bufferedPosition = bufferedPosition
        self.start = start
        self.end = end
        self.trackColor = trackColor
        self.bufferedColor = bufferedColor
        self.progressColor = progressColor
        self.trackHeight = trackHeight
        self.onInteractionStart = onInteractionStart
        self.onInteractionEnd = onInteractionEnd
        self.knob = knob()
    }

    var body: some View {
        GeometryReader { geo in
            let trackWidth = geo.size.width
            let difference = end - start

            // Calculate pixel positions directly
            let knobX = difference > 0 ? ((knobPosition - start) / difference) * trackWidth : 0
            let bufferedWidth =
                difference > 0 ? ((bufferedPosition - start) / difference) * trackWidth : 0
            let progressWidth = knobX

            let drag = DragGesture(minimumDistance: 0)
                .onChanged { newValue in
                    // Fire start callback once per gesture
                    if !didBeginInteraction {
                        didBeginInteraction = true
                        onInteractionStart?()
                    }
                    let dragX = Swift.max(0, Swift.min(newValue.location.x, trackWidth))
                    let fraction = dragX / trackWidth
                    let newPosition = start + (fraction * difference)
                    knobPosition = Swift.max(start, Swift.min(newPosition, end))
                }
                .onEnded { _ in
                    didBeginInteraction = false
                    onInteractionEnd?()
                }

            ZStack(alignment: .leading) {
                // 1. Background track - full width
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(trackColor)
                    .frame(width: trackWidth, height: trackHeight)

                // 2. Buffered rectangle - up to buffered position
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(bufferedColor)
                    .frame(width: Swift.max(0, bufferedWidth), height: trackHeight)
                    .animation(.linear(duration: 0.3), value: bufferedWidth)

                // 3. Progress rectangle - up to knob position
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(progressColor)
                    .frame(width: Swift.max(0, progressWidth), height: trackHeight)

                // Draggable knob
                knob
                    .position(x: knobX, y: geo.size.height / 2)
                    .simultaneousGesture(drag)
            }
            .frame(height: geo.size.height)
        }
    }
}

// Extension to provide a convenience init with default knob
extension ProgressSlider where Knob == AnyView {
    init(
        knobPosition: Binding<Double>,
        bufferedPosition: Double,
        start: Double,
        end: Double,
        trackColor: Color = Colors.TimelineColors.barUnplayed,
        bufferedColor: Color = Colors.TimelineColors.barLoaded,
        progressColor: Color = Colors.TimelineColors.barPlayed,
        trackHeight: CGFloat = 3
    ) {
        self.init(
            knobPosition: knobPosition,
            bufferedPosition: bufferedPosition,
            start: start,
            end: end,
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

#Preview("ProgressSlider") {
    @Previewable @State var position: Double = 30
    @Previewable @State var buffered: Double = 60

    VStack(spacing: 20) {
        ProgressSlider(
            knobPosition: $position,
            bufferedPosition: buffered,
            start: 0,
            end: 100
        )
        .frame(height: 40)

        Text("Position: \(Int(position)) | Buffered: \(Int(buffered))")
            .foregroundColor(.white)
    }
    .padding()
    .background(Colors.background)
}
