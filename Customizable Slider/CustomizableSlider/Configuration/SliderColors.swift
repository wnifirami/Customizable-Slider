import SwiftUI

/// Color tokens for `CustomizableSlider`.
public struct SliderColors: Equatable {
    public var track: Color
    public var fill: Color
    public var thumb: Color
    public var thumbShadow: Color
    public var stepTick: Color
    public var stepLabel: Color
    public var minimumLabel: Color
    public var maximumLabel: Color

    public init(
        track: Color = Color(.systemGray5),
        fill: Color = .blue,
        thumb: Color = .white,
        thumbShadow: Color = Color.black.opacity(0.20),
        stepTick: Color = Color(.systemGray3),
        stepLabel: Color = Color(.secondaryLabel),
        minimumLabel: Color = Color(.secondaryLabel),
        maximumLabel: Color = Color(.secondaryLabel)
    ) {
        self.track = track
        self.fill = fill
        self.thumb = thumb
        self.thumbShadow = thumbShadow
        self.stepTick = stepTick
        self.stepLabel = stepLabel
        self.minimumLabel = minimumLabel
        self.maximumLabel = maximumLabel
    }
}
