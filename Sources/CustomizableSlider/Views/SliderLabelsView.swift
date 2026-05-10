import SwiftUI

struct SliderLabelItem: Equatable {
    let fraction: Double
    let label: String
    let isMinimum: Bool
    let isMaximum: Bool
}

struct SliderLabelsView: View, Equatable {
    let labels: [SliderLabelItem]
    let configuration: SliderConfiguration

    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.labels == rhs.labels && lhs.configuration == rhs.configuration
    }

    var body: some View {
        GeometryReader { geometry in
            labelsContent(width: geometry.size.width)
        }
        .frame(height: 18)
    }

    private func labelsContent(width: CGFloat) -> some View {
        let thumbSize = configuration.appearance.thumbSize
        let thumbRadius = thumbSize / 2
        let usableWidth = width - thumbSize

        return ZStack(alignment: .topLeading) {
            ForEach(Array(nonOverlappingLabels(usableWidth: usableWidth).enumerated()), id: \.offset) { _, item in
                Text(item.label)
                    .font(font(for: item))
                    .foregroundStyle(color(for: item))
                    .fixedSize()
                    // .position sets the view's centre, matching the thumb centre at that fraction.
                    .position(
                        x: thumbRadius + CGFloat(item.fraction) * usableWidth,
                        y: 9
                    )
            }
        }
    }

    /// Greedy pass: always keep first and last, keep a middle label only when its
    /// centre is at least `minSpacing` points away from the previously placed label.
    private func nonOverlappingLabels(usableWidth: CGFloat) -> [SliderLabelItem] {
        guard labels.count > 1 else { return labels }

        if configuration.appearance.showOnlyBoundaryLabels {
            return [labels.first, labels.last].compactMap { $0 }
        }

        let minSpacing: CGFloat = 44
        var result: [SliderLabelItem] = []
        var lastPlacedX: CGFloat = -.greatestFiniteMagnitude

        for (index, item) in labels.enumerated() {
            let x = CGFloat(item.fraction) * usableWidth
            let isLast = index == labels.count - 1

            if isLast {
                if let previous = result.last {
                    let previousX = CGFloat(previous.fraction) * usableWidth
                    if x - previousX < minSpacing { result.removeLast() }
                }
                result.append(item)
            } else if x - lastPlacedX >= minSpacing {
                result.append(item)
                lastPlacedX = x
            }
        }

        return result
    }

    private func font(for item: SliderLabelItem) -> Font {
        if item.isMinimum { return configuration.typography.minimumLabel }
        if item.isMaximum { return configuration.typography.maximumLabel }
        return configuration.typography.stepLabel
    }

    private func color(for item: SliderLabelItem) -> Color {
        if item.isMinimum { return configuration.colors.minimumLabel }
        if item.isMaximum { return configuration.colors.maximumLabel }
        return configuration.colors.stepLabel
    }
}
