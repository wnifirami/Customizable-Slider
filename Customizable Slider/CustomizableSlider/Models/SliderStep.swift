import Foundation

/// A discrete value on the slider, with an optional display label.
public struct SliderStep<V: BinaryFloatingPoint & Sendable>: Sendable, Equatable {
    public let value: V
    public let label: String?

    public init(value: V, label: String? = nil) {
        self.value = value
        self.label = label
    }
}
