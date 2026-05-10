import SwiftUI

/// A generic, fully customisable slider that supports discrete steps, range-based continuous
/// values, optional labels, configurable thumb and track appearance, and VoiceOver adjustability.
///
/// **Stepped (loan-style) usage:**
/// ```swift
/// CustomizableSlider(
///     value: $loanAmount,
///     steps: [
///         SliderStep(value: 1_000.0, label: "$1K"),
///         SliderStep(value: 10_000.0, label: "$10K"),
///         SliderStep(value: 100_000.0, label: "$100K"),
///     ]
/// )
/// ```
///
/// **Range-based usage:**
/// ```swift
/// CustomizableSlider(value: $volume, in: 0...100, step: 10, minimumLabel: "0%", maximumLabel: "100%")
/// ```
public struct CustomizableSlider<V: BinaryFloatingPoint & Sendable>: View {
    @Binding private var value: V
    private let steps: [SliderStep<V>]
    private let configuration: SliderConfiguration
    private let sliderAccessibilityLabel: String

    @State private var viewModel = SliderViewModel()

    // MARK: - Init (explicit steps)

    /// Creates a slider from an explicit array of discrete steps.
    ///
    /// - Parameters:
    ///   - value: The currently selected value. Must fall within the range defined by the steps.
    ///   - steps: At least two steps in ascending value order.
    ///   - configuration: Visual and behavioural configuration. Defaults to `.default`.
    ///   - accessibilityLabel: VoiceOver label for the control.
    public init(
        value: Binding<V>,
        steps: [SliderStep<V>],
        configuration: SliderConfiguration = .default,
        accessibilityLabel: String = "Slider"
    ) {
        precondition(steps.count >= 2, "CustomizableSlider requires at least two steps.")
        _value = value
        self.steps = steps
        self.configuration = configuration
        self.sliderAccessibilityLabel = accessibilityLabel
    }

    // MARK: - Init (range)

    /// Creates a slider from a closed range, generating a step at every `step` interval.
    ///
    /// - Parameters:
    ///   - value: The currently selected value.
    ///   - range: The minimum and maximum bounds.
    ///   - step: Interval between generated steps. Defaults to `1`.
    ///   - minimumLabel: Optional label shown at the minimum end.
    ///   - maximumLabel: Optional label shown at the maximum end.
    ///   - configuration: Visual and behavioural configuration. Defaults to `.default`.
    ///   - accessibilityLabel: VoiceOver label for the control.
    public init(
        value: Binding<V>,
        in range: ClosedRange<V>,
        step: V = 1,
        minimumLabel: String? = nil,
        maximumLabel: String? = nil,
        configuration: SliderConfiguration = .default,
        accessibilityLabel: String = "Slider"
    ) {
        var generatedSteps: [SliderStep<V>] = []
        var current = range.lowerBound
        while current < range.upperBound {
            let label: String? = current == range.lowerBound ? minimumLabel : nil
            generatedSteps.append(SliderStep(value: current, label: label))
            current += step
        }
        generatedSteps.append(SliderStep(value: range.upperBound, label: maximumLabel))

        if generatedSteps.count < 2 {
            generatedSteps = [
                SliderStep(value: range.lowerBound, label: minimumLabel),
                SliderStep(value: range.upperBound, label: maximumLabel),
            ]
        }

        self.init(
            value: value,
            steps: generatedSteps,
            configuration: configuration,
            accessibilityLabel: accessibilityLabel
        )
    }

    // MARK: - Body

    public var body: some View {
        VStack(spacing: 0) {
            GeometryReader { geometry in
                sliderInteractiveArea(width: geometry.size.width)
            }
            .frame(height: configuration.appearance.thumbSize)
            .padding(.horizontal, configuration.spacing.horizontalPadding)

            if configuration.appearance.showLabels, !visibleLabels.isEmpty {
                SliderLabelsView(labels: visibleLabels, configuration: configuration)
                    .equatable()
                    .padding(.horizontal, configuration.spacing.horizontalPadding)
                    .padding(.top, configuration.spacing.labelTopPadding)
            }
        }
    }

    // MARK: - Private helpers

    private var minimumValue: V { steps.first!.value }
    private var maximumValue: V { steps.last!.value }

    private var currentFraction: Double {
        SliderMath.fraction(value: value, minimum: minimumValue, maximum: maximumValue)
    }

    private var allStepFractions: [Double] {
        SliderMath.stepFractions(values: steps.map(\.value), minimum: minimumValue, maximum: maximumValue)
    }

    private var visibleLabels: [SliderLabelItem] {
        let fractions = allStepFractions
        return steps.enumerated().compactMap { index, step in
            guard let label = step.label else { return nil }
            return SliderLabelItem(
                fraction: fractions[index],
                label: label,
                isMinimum: index == 0,
                isMaximum: index == steps.count - 1
            )
        }
    }

    private var accessibilityValueDescription: String {
        if let matchingStep = steps.first(where: { $0.value == value }),
           let label = matchingStep.label {
            return label
        }
        return String(format: "%.0f", Double(value))
    }

    // MARK: - Slider area

    @ViewBuilder
    private func sliderInteractiveArea(width: CGFloat) -> some View {
        ZStack(alignment: .leading) {
            SliderTrackView(
                fraction: currentFraction,
                stepFractions: allStepFractions,
                configuration: configuration
            )
            .equatable()

            if configuration.appearance.showDragIndicator {
                SliderThumbView(
                    fraction: currentFraction,
                    isDragging: viewModel.isDragging,
                    configuration: configuration
                )
                .equatable()
            }
        }
        .contentShape(Rectangle())
        .gesture(dragGesture(trackWidth: width))
        .accessibilityElement()
        .accessibilityLabel(sliderAccessibilityLabel)
        .accessibilityValue(Text(accessibilityValueDescription))
        .accessibilityAdjustableAction { direction in
            handleAccessibilityAdjustment(direction)
        }
    }

    // MARK: - Interaction

    private func dragGesture(trackWidth: CGFloat) -> some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { gesture in
                viewModel.isDragging = true
                let fraction = SliderMath.fraction(
                    dragX: gesture.location.x,
                    trackWidth: trackWidth,
                    thumbSize: configuration.appearance.thumbSize
                )
                applyFraction(fraction)
            }
            .onEnded { _ in
                withAnimation(.spring(response: 0.38, dampingFraction: 0.82)) {
                    viewModel.isDragging = false
                }
            }
    }

    private func applyFraction(_ fraction: Double) {
        if configuration.appearance.snapsToSteps {
            let nearestIndex = SliderMath.nearestStepIndex(to: fraction, among: allStepFractions)
            value = steps[nearestIndex].value
        } else {
            value = SliderMath.value(at: fraction, minimum: minimumValue, maximum: maximumValue)
        }
    }

    private func handleAccessibilityAdjustment(_ direction: AccessibilityAdjustmentDirection) {
        let currentIndex = SliderMath.nearestStepIndex(to: currentFraction, among: allStepFractions)
        switch direction {
        case .increment:
            guard currentIndex < steps.count - 1 else { return }
            withAnimation(.spring(response: 0.38, dampingFraction: 0.82)) {
                value = steps[currentIndex + 1].value
            }
        case .decrement:
            guard currentIndex > 0 else { return }
            withAnimation(.spring(response: 0.38, dampingFraction: 0.82)) {
                value = steps[currentIndex - 1].value
            }
        @unknown default:
            break
        }
    }
}
