import SwiftUI

struct SliderTrackView: View, Equatable {
    let fraction: Double
    let stepFractions: [Double]
    let configuration: SliderConfiguration

    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.fraction == rhs.fraction &&
        lhs.stepFractions == rhs.stepFractions &&
        lhs.configuration == rhs.configuration
    }

    var body: some View {
        GeometryReader { geometry in
            trackContent(width: geometry.size.width)
        }
    }

    private func trackContent(width: CGFloat) -> some View {
        let thumbSize = configuration.appearance.thumbSize
        let thumbRadius = thumbSize / 2
        let trackHeight = configuration.appearance.trackHeight
        // Fill extends from leading edge to the thumb's centre position.
        let fillWidth = max(0, thumbRadius + CGFloat(fraction) * (width - thumbSize))

        return ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: configuration.appearance.trackCornerRadius)
                .fill(configuration.colors.track)
                .frame(width: width, height: trackHeight)

            RoundedRectangle(cornerRadius: configuration.appearance.trackCornerRadius)
                .fill(configuration.colors.fill)
                .frame(width: fillWidth, height: trackHeight)

            if configuration.appearance.showStepTicks {
                ForEach(Array(stepFractions.enumerated()), id: \.offset) { _, stepFraction in
                    // Tick is 2 pt wide; subtract 1 so its centre aligns with the step.
                    Capsule()
                        .fill(configuration.colors.stepTick)
                        .frame(width: 2, height: trackHeight + 4)
                        .offset(x: thumbRadius + CGFloat(stepFraction) * (width - thumbSize) - 1)
                }
            }
        }
        .frame(maxHeight: .infinity, alignment: .center)
    }
}
