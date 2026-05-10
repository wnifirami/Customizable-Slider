import SwiftUI

/// Visual shape and behaviour tokens for `CustomizableSlider`.
public struct SliderAppearance: Equatable {
    /// Height of the track bar in points.
    public var trackHeight: CGFloat
    /// Width and height of the draggable thumb.
    public var thumbSize: CGFloat
    /// Corner radius of the thumb. Set to half of `thumbSize` for a circle.
    public var thumbCornerRadius: CGFloat
    /// When `false` the thumb is hidden; the track is still interactive.
    public var showDragIndicator: Bool
    /// Whether to draw a small tick mark at each step position.
    public var showStepTicks: Bool
    /// When `true`, dragging snaps the value to the nearest step. When `false`, the value is interpolated freely.
    public var snapsToSteps: Bool
    /// Corner radius of the track bar.
    public var trackCornerRadius: CGFloat
    /// Whether to render the label row beneath the track.
    public var showLabels: Bool
    /// When `true`, only the minimum and maximum labels are shown. When `false`, all step labels
    /// are shown with automatic overlap prevention.
    public var showOnlyBoundaryLabels: Bool

    public init(
        trackHeight: CGFloat = 6,
        thumbSize: CGFloat = 28,
        thumbCornerRadius: CGFloat = 14,
        showDragIndicator: Bool = true,
        showStepTicks: Bool = true,
        snapsToSteps: Bool = true,
        trackCornerRadius: CGFloat = 3,
        showLabels: Bool = true,
        showOnlyBoundaryLabels: Bool = false
    ) {
        self.trackHeight = trackHeight
        self.thumbSize = thumbSize
        self.thumbCornerRadius = thumbCornerRadius
        self.showDragIndicator = showDragIndicator
        self.showStepTicks = showStepTicks
        self.snapsToSteps = snapsToSteps
        self.trackCornerRadius = trackCornerRadius
        self.showLabels = showLabels
        self.showOnlyBoundaryLabels = showOnlyBoundaryLabels
    }
}
