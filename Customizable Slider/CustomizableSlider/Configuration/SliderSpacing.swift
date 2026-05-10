import SwiftUI

/// Spacing and padding tokens for `CustomizableSlider`.
public struct SliderSpacing: Equatable {
    /// Vertical gap between the track and the label row.
    public var labelTopPadding: CGFloat
    /// Leading and trailing inset applied to the entire slider.
    public var horizontalPadding: CGFloat

    public init(
        labelTopPadding: CGFloat = 8,
        horizontalPadding: CGFloat = 0
    ) {
        self.labelTopPadding = labelTopPadding
        self.horizontalPadding = horizontalPadding
    }
}
