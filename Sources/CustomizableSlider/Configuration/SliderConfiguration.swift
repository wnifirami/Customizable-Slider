import SwiftUI

/// All configuration for `CustomizableSlider`. Start from `.default` and mutate only what you need.
///
/// ```swift
/// var config = SliderConfiguration.default
/// config.colors.fill = Color(red: 0.04, green: 0.65, blue: 0.91)
/// config.appearance.thumbCornerRadius = 6
/// CustomizableSlider(value: $amount, steps: steps, configuration: config)
/// ```
public struct SliderConfiguration: Equatable {
    public var colors: SliderColors
    public var typography: SliderTypography
    public var spacing: SliderSpacing
    public var appearance: SliderAppearance

    public static let `default` = SliderConfiguration()

    public init(
        colors: SliderColors = SliderColors(),
        typography: SliderTypography = SliderTypography(),
        spacing: SliderSpacing = SliderSpacing(),
        appearance: SliderAppearance = SliderAppearance()
    ) {
        self.colors = colors
        self.typography = typography
        self.spacing = spacing
        self.appearance = appearance
    }
}
