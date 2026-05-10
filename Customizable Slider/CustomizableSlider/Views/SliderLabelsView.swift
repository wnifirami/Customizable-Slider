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

        return ZStack(alignment: .topLeading) {
            ForEach(Array(labels.enumerated()), id: \.offset) { _, item in
                Text(item.label)
                    .font(font(for: item))
                    .foregroundStyle(color(for: item))
                    .fixedSize()
                    // .position sets the view's centre, matching the thumb centre at that fraction.
                    .position(
                        x: thumbRadius + CGFloat(item.fraction) * (width - thumbSize),
                        y: 9
                    )
            }
        }
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
