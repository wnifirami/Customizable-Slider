import SwiftUI

extension SliderConfiguration {
    static var ocean: SliderConfiguration {
        var config = SliderConfiguration.default
        config.colors.fill   = Color(red: 0.04, green: 0.65, blue: 0.91)
        config.colors.track  = Color(red: 0.04, green: 0.65, blue: 0.91).opacity(0.18)
        config.colors.thumb  = .white
        config.appearance.thumbCornerRadius = 6
        return config
    }

    static var sunset: SliderConfiguration {
        var config = SliderConfiguration.default
        config.colors.fill        = Color(red: 0.97, green: 0.37, blue: 0.26)
        config.colors.track       = Color(red: 0.97, green: 0.37, blue: 0.26).opacity(0.18)
        config.colors.thumb       = Color(red: 1.0, green: 0.85, blue: 0.4)
        config.colors.thumbShadow = Color(red: 0.97, green: 0.37, blue: 0.26).opacity(0.35)
        return config
    }

    static var minimal: SliderConfiguration {
        var config = SliderConfiguration.default
        config.colors.fill        = .primary
        config.colors.track       = Color(.systemGray5)
        config.colors.thumb       = Color(.systemBackground)
        config.colors.thumbShadow = Color.black.opacity(0.15)
        config.appearance.thumbSize         = 22
        config.appearance.thumbCornerRadius = 11
        config.appearance.showStepTicks     = false
        return config
    }
}
