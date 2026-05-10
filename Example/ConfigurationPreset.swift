enum ConfigurationPreset: String, CaseIterable {
    case `default` = "Default"
    case ocean     = "Ocean"
    case sunset    = "Sunset"
    case minimal   = "Minimal"

    var sliderConfiguration: SliderConfiguration {
        switch self {
        case .default: return .default
        case .ocean:   return .ocean
        case .sunset:  return .sunset
        case .minimal: return .minimal
        }
    }
}
