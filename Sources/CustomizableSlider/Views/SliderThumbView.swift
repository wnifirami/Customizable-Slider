import SwiftUI

struct SliderThumbView: View, Equatable {
    let fraction: Double
    let isDragging: Bool
    let configuration: SliderConfiguration

    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.fraction == rhs.fraction &&
        lhs.isDragging == rhs.isDragging &&
        lhs.configuration == rhs.configuration
    }

    var body: some View {
        GeometryReader { geometry in
            thumbContent(width: geometry.size.width)
        }
    }

    private func thumbContent(width: CGFloat) -> some View {
        let thumbSize = configuration.appearance.thumbSize
        let offsetX = SliderMath.thumbLeadingOffset(fraction: fraction, trackWidth: width, thumbSize: thumbSize)

        return RoundedRectangle(cornerRadius: configuration.appearance.thumbCornerRadius)
            .fill(configuration.colors.thumb)
            .shadow(
                color: configuration.colors.thumbShadow,
                radius: isDragging ? 8 : 4,
                y: isDragging ? 4 : 2
            )
            .frame(width: thumbSize, height: thumbSize)
            .scaleEffect(isDragging ? 1.12 : 1.0)
            .offset(x: offsetX)
            .frame(maxHeight: .infinity, alignment: .center)
            .animation(.spring(response: 0.38, dampingFraction: 0.82), value: isDragging)
    }
}
