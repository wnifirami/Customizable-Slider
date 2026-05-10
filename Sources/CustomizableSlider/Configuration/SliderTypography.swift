import SwiftUI

/// Font tokens for `CustomizableSlider` labels.
public struct SliderTypography: Equatable {
    public var stepLabel: Font
    public var minimumLabel: Font
    public var maximumLabel: Font

    public init(
        stepLabel: Font = .caption2,
        minimumLabel: Font = .caption2,
        maximumLabel: Font = .caption2
    ) {
        self.stepLabel = stepLabel
        self.minimumLabel = minimumLabel
        self.maximumLabel = maximumLabel
    }
}
