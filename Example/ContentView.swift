import SwiftUI

struct ContentView: View {
    @State private var loanAmount: Double = 10_000
    @State private var volume: Double = 60
    @State private var rating: Double = 3
    @State private var temperature: Double = 20

    @State private var activePreset: ConfigurationPreset = .default
    @State private var showsDragIndicator: Bool = true
    @State private var showsOnlyBoundaryLabels: Bool = false
    @State private var showsConfigurationSheet: Bool = false

    private let loanSteps: [SliderStep<Double>] = [
        SliderStep(value: 1_000,   label: "$1K"),
        SliderStep(value: 5_000,   label: "$5K"),
        SliderStep(value: 10_000,  label: "$10K"),
        SliderStep(value: 25_000,  label: "$25K"),
        SliderStep(value: 50_000,  label: "$50K"),
        SliderStep(value: 100_000, label: "$100K"),
    ]

    private static let ratingSteps: [SliderStep<Double>] =
        (1...5).map { SliderStep(value: Double($0), label: "\($0)") }

    private var configuration: SliderConfiguration {
        var config = activePreset.sliderConfiguration
        config.appearance.showDragIndicator = showsDragIndicator
        config.appearance.showOnlyBoundaryLabels = showsOnlyBoundaryLabels
        return config
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 36) {
                    loanSection
                    Divider()
                    volumeSection
                    Divider()
                    ratingSection
                    Divider()
                    temperatureSection
                }
                .padding(24)
            }
            .navigationTitle("Sliders")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Theme") { showsConfigurationSheet = true }
                }
            }
            .sheet(isPresented: $showsConfigurationSheet) {
                ConfigurationSheet(
                    activePreset: $activePreset,
                    showsDragIndicator: $showsDragIndicator,
                    showsOnlyBoundaryLabels: $showsOnlyBoundaryLabels
                )
            }
        }
    }

    // MARK: - Sections

    private var loanSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .firstTextBaseline) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Loan Amount")
                        .font(.headline)
                    Text("Snap to common amounts")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Text(loanAmount, format: .currency(code: "USD").precision(.fractionLength(0)))
                    .font(.title3.bold())
                    .monospacedDigit()
                    .foregroundStyle(configuration.colors.fill)
            }

            CustomizableSlider(
                value: $loanAmount,
                steps: loanSteps,
                configuration: configuration,
                accessibilityLabel: "Loan amount"
            )
        }
    }

    private var volumeSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .firstTextBaseline) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Volume")
                        .font(.headline)
                    Text("Continuous, no snapping")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Text("\(Int(volume))%")
                    .font(.title3.bold())
                    .monospacedDigit()
                    .foregroundStyle(configuration.colors.fill)
            }

            CustomizableSlider(
                value: $volume,
                in: 0...100,
                step: 1,
                minimumLabel: "0%",
                maximumLabel: "100%",
                configuration: volumeConfiguration,
                accessibilityLabel: "Volume"
            )
        }
    }

    private var volumeConfiguration: SliderConfiguration {
        var config = configuration
        config.appearance.showStepTicks = false
        config.appearance.snapsToSteps = false
        return config
    }

    private var ratingSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .firstTextBaseline) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Rating")
                        .font(.headline)
                    Text("Integer steps 1–5")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Text(String(repeating: "★", count: Int(rating)))
                    .font(.title3)
                    .foregroundStyle(configuration.colors.fill)
            }

            CustomizableSlider(
                value: $rating,
                steps: Self.ratingSteps,
                configuration: configuration,
                accessibilityLabel: "Rating"
            )
        }
    }

    private var temperatureSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .firstTextBaseline) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Temperature")
                        .font(.headline)
                    Text("Thick track, step 5°")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Text("\(Int(temperature))°C")
                    .font(.title3.bold())
                    .monospacedDigit()
                    .foregroundStyle(configuration.colors.fill)
            }

            CustomizableSlider(
                value: $temperature,
                in: 0...40,
                step: 5,
                minimumLabel: "0°",
                maximumLabel: "40°",
                configuration: temperatureConfiguration,
                accessibilityLabel: "Temperature"
            )
        }
    }

    private var temperatureConfiguration: SliderConfiguration {
        var config = configuration
        config.appearance.trackHeight = 16
        config.appearance.trackCornerRadius = 8
        return config
    }
}

#Preview {
    ContentView()
}
