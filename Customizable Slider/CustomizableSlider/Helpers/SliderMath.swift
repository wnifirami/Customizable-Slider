import CoreGraphics

/// Pure stateless computation helpers. All functions are tested in `SliderMathTests`.
enum SliderMath {

    /// Normalises `value` to [0, 1] within [minimum, maximum].
    static func fraction<V: BinaryFloatingPoint>(value: V, minimum: V, maximum: V) -> Double {
        let range = Double(maximum - minimum)
        guard range > 0 else { return 0 }
        return Double(value - minimum) / range
    }

    /// Maps every value in `values` to its normalised fraction.
    static func stepFractions<V: BinaryFloatingPoint>(values: [V], minimum: V, maximum: V) -> [Double] {
        values.map { fraction(value: $0, minimum: minimum, maximum: maximum) }
    }

    /// Returns the index of the step fraction closest to `target`.
    static func nearestStepIndex(to target: Double, among stepFractions: [Double]) -> Int {
        guard !stepFractions.isEmpty else { return 0 }
        return stepFractions.indices.min(by: {
            abs(stepFractions[$0] - target) < abs(stepFractions[$1] - target)
        })!
    }

    /// Converts a raw drag x-position to a normalised fraction, accounting for thumb inset.
    static func fraction(dragX: CGFloat, trackWidth: CGFloat, thumbSize: CGFloat) -> Double {
        let usableWidth = Double(trackWidth - thumbSize)
        guard usableWidth > 0 else { return 0 }
        let adjustedX = Double(dragX) - Double(thumbSize) / 2
        return Swift.max(0, Swift.min(1, adjustedX / usableWidth))
    }

    /// Linearly interpolates a value from a fraction.
    static func value<V: BinaryFloatingPoint>(at fraction: Double, minimum: V, maximum: V) -> V {
        minimum + V(Swift.max(0.0, Swift.min(1.0, fraction))) * (maximum - minimum)
    }

    /// The x-offset for the thumb's leading edge so its centre aligns with `fraction`.
    static func thumbLeadingOffset(fraction: Double, trackWidth: CGFloat, thumbSize: CGFloat) -> CGFloat {
        CGFloat(fraction) * (trackWidth - thumbSize)
    }
}
