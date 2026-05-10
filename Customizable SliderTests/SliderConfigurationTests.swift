import XCTest
@testable import Customizable_Slider

@MainActor
final class SliderConfigurationTests: XCTestCase {

    // MARK: - Default

    func testDefaultConfigurationIsEqualToAnotherDefault() {
        XCTAssertEqual(SliderConfiguration.default, SliderConfiguration.default)
    }

    func testDefaultAppearanceValues() {
        let appearance = SliderConfiguration.default.appearance
        XCTAssertEqual(appearance.trackHeight, 6)
        XCTAssertEqual(appearance.thumbSize, 28)
        XCTAssertEqual(appearance.thumbCornerRadius, 14)
        XCTAssertTrue(appearance.showDragIndicator)
        XCTAssertTrue(appearance.showStepTicks)
        XCTAssertTrue(appearance.snapsToSteps)
        XCTAssertTrue(appearance.showLabels)
    }

    // MARK: - Value semantics (mutating a copy must not affect the original)

    func testMutatingCopyColorsDoesNotAffectOriginal() {
        let original = SliderConfiguration.default
        var copy = original
        copy.colors.fill = .red
        XCTAssertNotEqual(copy.colors, original.colors)
    }

    func testMutatingCopyAppearanceDoesNotAffectOriginal() {
        let original = SliderConfiguration.default
        var copy = original
        copy.appearance.thumbSize = 40
        XCTAssertNotEqual(copy.appearance, original.appearance)
        XCTAssertEqual(original.appearance.thumbSize, 28)
    }

    func testMutatingCopyTypographyDoesNotAffectOriginal() {
        let original = SliderConfiguration.default
        var copy = original
        copy.typography.stepLabel = .headline
        XCTAssertNotEqual(copy.typography, original.typography)
    }

    func testMutatingCopySpacingDoesNotAffectOriginal() {
        let original = SliderConfiguration.default
        var copy = original
        copy.spacing.labelTopPadding = 20
        XCTAssertNotEqual(copy.spacing, original.spacing)
        XCTAssertEqual(original.spacing.labelTopPadding, 8)
    }

    // MARK: - Equatable

    func testConfigurationsWithSameValuesAreEqual() {
        let first  = SliderConfiguration.default
        let second = SliderConfiguration.default
        XCTAssertEqual(first, second)
    }

    func testConfigurationsWithDifferentFillColorAreNotEqual() {
        let first  = SliderConfiguration.default
        var second = SliderConfiguration.default
        second.colors.fill = .orange
        XCTAssertNotEqual(first, second)
    }

    func testConfigurationsWithDifferentAppearanceAreNotEqual() {
        let first  = SliderConfiguration.default
        var second = SliderConfiguration.default
        second.appearance.showDragIndicator = false
        XCTAssertNotEqual(first, second)
    }

    // MARK: - SliderStep

    func testSliderStepEquality() {
        let stepA = SliderStep(value: 10.0, label: "10")
        let stepB = SliderStep(value: 10.0, label: "10")
        XCTAssertEqual(stepA, stepB)
    }

    func testSliderStepInequalityOnValue() {
        let stepA = SliderStep(value: 10.0, label: "10")
        let stepB = SliderStep(value: 20.0, label: "10")
        XCTAssertNotEqual(stepA, stepB)
    }

    func testSliderStepInequalityOnLabel() {
        let stepA = SliderStep(value: 10.0, label: "Ten")
        let stepB = SliderStep(value: 10.0, label: "10")
        XCTAssertNotEqual(stepA, stepB)
    }

    func testSliderStepWithNilLabel() {
        let stepA = SliderStep(value: 5.0, label: nil)
        let stepB = SliderStep(value: 5.0)
        XCTAssertEqual(stepA, stepB)
    }
}
