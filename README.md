# CustomizableSlider

A lightweight, fully generic SwiftUI slider component for iOS. Drop it in, pass a binding for the current value, choose between discrete steps or a continuous range, and configure every visual detail — colors, typography, spacing, and thumb shape — through a single `SliderConfiguration` value.

---

## Preview

<p align="center">
  <img src="Screenshots/sliders.png" width="30%" alt="All sliders" />
  &nbsp;&nbsp;
  <img src="Screenshots/themes.png" width="30%" alt="Theme presets" />
  &nbsp;&nbsp;
  <img src="Screenshots/settings.png" width="30%" alt="Configuration sheet" />
</p>

---

## Features

- **Discrete steps** — snap to an explicit list of labeled values (loan amounts, star ratings, etc.)
- **Continuous range** — freely interpolate between a `ClosedRange` with any step interval
- **Step ticks** — optional tick marks drawn at every step position on the track
- **Label row** — auto-positioned labels beneath the track with built-in overlap prevention
- **Boundary-only labels** — toggle to show only the minimum and maximum labels
- **Configurable thumb** — size, corner radius, shadow, and show/hide
- **Theme presets** — ocean, sunset, and minimal built-in; define your own with a one-liner extension
- **VoiceOver** — fully adjustable via `accessibilityAdjustableAction`
- **Zero dependencies** — pure SwiftUI, no third-party packages

---

## Requirements

| | Minimum |
|---|---|
| iOS | 17.0 |
| macOS | 14.0 |
| Swift | 5.9 |
| Xcode | 15.0 |

---

## Installation

### Swift Package Manager

**Xcode:** File → Add Package Dependencies, paste the URL below, select *Up to Next Major Version* from `1.0.0`.

```
https://github.com/wnifirami/Customizable-Slider.git
```

**Package.swift:**

```swift
dependencies: [
    .package(url: "https://github.com/wnifirami/Customizable-Slider.git", from: "1.0.0")
],
targets: [
    .target(name: "YourApp", dependencies: ["CustomizableSlider"])
]
```

---

## Quick start

### Discrete steps

```swift
import SwiftUI
import CustomizableSlider

struct ContentView: View {
    @State private var loanAmount: Double = 10_000

    private let steps: [SliderStep<Double>] = [
        SliderStep(value: 1_000,   label: "$1K"),
        SliderStep(value: 10_000,  label: "$10K"),
        SliderStep(value: 50_000,  label: "$50K"),
        SliderStep(value: 100_000, label: "$100K"),
    ]

    var body: some View {
        CustomizableSlider(value: $loanAmount, steps: steps)
    }
}
```

### Continuous range

```swift
@State private var volume: Double = 60

CustomizableSlider(
    value: $volume,
    in: 0...100,
    step: 1,
    minimumLabel: "0%",
    maximumLabel: "100%"
)
```

When the user drags, `value` updates automatically.

---

## Configuration

Every visual property comes from `SliderConfiguration`. Start from `.default` and mutate only what you need.

```swift
var config = SliderConfiguration.default
config.colors.fill                       = Color(red: 0.04, green: 0.65, blue: 0.91)
config.colors.track                      = Color(red: 0.04, green: 0.65, blue: 0.91).opacity(0.18)
config.appearance.thumbCornerRadius      = 6
config.appearance.showOnlyBoundaryLabels = true

CustomizableSlider(value: $amount, steps: steps, configuration: config)
```

Configuration is a value type — assigning a new value updates the slider live.

### Built-in presets

```swift
CustomizableSlider(value: $value, steps: steps, configuration: .ocean)
CustomizableSlider(value: $value, steps: steps, configuration: .sunset)
CustomizableSlider(value: $value, steps: steps, configuration: .minimal)
```

### Define your own preset

```swift
extension SliderConfiguration {
    static var brand: SliderConfiguration {
        var config = SliderConfiguration.default
        config.colors.fill  = Color(red: 0.42, green: 0.13, blue: 0.63)
        config.colors.track = Color(red: 0.42, green: 0.13, blue: 0.63).opacity(0.18)
        return config
    }
}
```

---

## SliderConfiguration reference

### Colors — `config.colors`

| Property | Default | Description |
|---|---|---|
| `track` | `Color(.systemGray5)` | Empty track background |
| `fill` | `.blue` | Filled portion of the track |
| `thumb` | `.white` | Draggable thumb fill |
| `thumbShadow` | `Color.black.opacity(0.20)` | Thumb drop shadow |
| `stepTick` | `Color(.systemGray3)` | Tick marks at each step |
| `stepLabel` | `Color(.secondaryLabel)` | Middle step labels |
| `minimumLabel` | `Color(.secondaryLabel)` | Label at the minimum end |
| `maximumLabel` | `Color(.secondaryLabel)` | Label at the maximum end |

### Typography — `config.typography`

| Property | Default | Description |
|---|---|---|
| `stepLabel` | `.caption2` | Middle step label font |
| `minimumLabel` | `.caption2` | Minimum end label font |
| `maximumLabel` | `.caption2` | Maximum end label font |

### Spacing — `config.spacing`

| Property | Default | Description |
|---|---|---|
| `labelTopPadding` | `8` | Gap between track and label row (pts) |
| `horizontalPadding` | `0` | Leading and trailing inset (pts) |

### Appearance — `config.appearance`

| Property | Default | Description |
|---|---|---|
| `trackHeight` | `6` | Track bar height in points |
| `thumbSize` | `28` | Thumb width and height in points |
| `thumbCornerRadius` | `14` | Thumb corner radius (`thumbSize / 2` = full circle) |
| `trackCornerRadius` | `3` | Track bar corner radius |
| `showDragIndicator` | `true` | Show or hide the draggable thumb |
| `showStepTicks` | `true` | Draw tick marks at each step position |
| `snapsToSteps` | `true` | Snap to nearest step vs. interpolate freely |
| `showLabels` | `true` | Render the label row beneath the track |
| `showOnlyBoundaryLabels` | `false` | Show only the min and max labels |

---

## CustomizableSlider parameters

### Stepped initializer

| Parameter | Type | Default | Description |
|---|---|---|---|
| `value` | `Binding<V>` | — | Currently selected value (required) |
| `steps` | `[SliderStep<V>]` | — | At least 2 steps in ascending order (required) |
| `configuration` | `SliderConfiguration` | `.default` | Visual and behavioural configuration |
| `accessibilityLabel` | `String` | `"Slider"` | VoiceOver label for the control |

### Range initializer

| Parameter | Type | Default | Description |
|---|---|---|---|
| `value` | `Binding<V>` | — | Currently selected value (required) |
| `in` | `ClosedRange<V>` | — | Minimum and maximum bounds (required) |
| `step` | `V` | `1` | Interval between generated steps |
| `minimumLabel` | `String?` | `nil` | Label shown at the minimum end |
| `maximumLabel` | `String?` | `nil` | Label shown at the maximum end |
| `configuration` | `SliderConfiguration` | `.default` | Visual and behavioural configuration |
| `accessibilityLabel` | `String` | `"Slider"` | VoiceOver label for the control |

---

## Project structure

```
CustomizableSlider/
├── Package.swift
├── Sources/CustomizableSlider/
│   ├── CustomizableSlider.swift         ← public entry point
│   ├── SliderViewModel.swift            ← internal drag state
│   ├── Configuration/
│   │   ├── SliderConfiguration.swift    ← public, Equatable, static .default
│   │   ├── SliderColors.swift
│   │   ├── SliderTypography.swift
│   │   ├── SliderSpacing.swift
│   │   └── SliderAppearance.swift
│   ├── Models/
│   │   └── SliderStep.swift             ← public, generic over BinaryFloatingPoint
│   ├── Views/
│   │   ├── SliderTrackView.swift        ← internal, Equatable
│   │   ├── SliderThumbView.swift        ← internal, Equatable
│   │   └── SliderLabelsView.swift       ← internal, Equatable, overlap-aware
│   └── Helpers/
│       └── SliderMath.swift             ← internal, pure stateless math
├── Example/
│   ├── ExampleApp.swift
│   ├── ContentView.swift                ← loan, volume, rating, temperature demos
│   ├── ConfigurationSheet.swift         ← live theme picker
│   ├── ConfigurationPreset.swift        ← ocean / sunset / minimal enum
│   └── SliderConfiguration+Presets.swift
├── CustomizableSliderTests/
│   ├── SliderConfigurationTests.swift
│   └── SliderMathTests.swift
└── Screenshots/
```

---

## Running the example

Open `Customizable Slider.xcodeproj` in Xcode 15+, select the **Customizable Slider** scheme, and run on an iOS 17+ simulator.

The example app demonstrates:
- A loan amount slider with discrete labeled steps and snap behaviour
- A volume slider in continuous mode with snapping and ticks disabled
- A 1–5 star rating slider with integer steps
- A temperature slider with a thick track and step interval of 5°
- A live theme sheet with all configuration toggles and built-in presets

---

## License

MIT — see [LICENSE](LICENSE).

© 2026 Rami Ounifi
