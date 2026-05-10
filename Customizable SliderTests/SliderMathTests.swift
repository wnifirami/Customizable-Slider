import XCTest
@testable import Customizable_Slider

@MainActor
final class SliderMathTests: XCTestCase {

    // MARK: - fraction(value:minimum:maximum:)

    func testFractionAtMinimumIsZero() {
        XCTAssertEqual(SliderMath.fraction(value: 0.0, minimum: 0.0, maximum: 100.0), 0.0)
    }

    func testFractionAtMaximumIsOne() {
        XCTAssertEqual(SliderMath.fraction(value: 100.0, minimum: 0.0, maximum: 100.0), 1.0)
    }

    func testFractionAtMidpoint() {
        XCTAssertEqual(SliderMath.fraction(value: 50.0, minimum: 0.0, maximum: 100.0), 0.5)
    }

    func testFractionWithNonZeroLowerBound() {
        XCTAssertEqual(SliderMath.fraction(value: 5_000.0, minimum: 1_000.0, maximum: 10_000.0), 0.444, accuracy: 0.001)
    }

    func testFractionWithZeroRangeReturnsZero() {
        XCTAssertEqual(SliderMath.fraction(value: 5.0, minimum: 5.0, maximum: 5.0), 0.0)
    }

    // MARK: - stepFractions(values:minimum:maximum:)

    func testStepFractionsCountMatchesInput() {
        let values = [0.0, 25.0, 50.0, 75.0, 100.0]
        let fractions = SliderMath.stepFractions(values: values, minimum: 0.0, maximum: 100.0)
        XCTAssertEqual(fractions.count, 5)
    }

    func testStepFractionsFirstIsZeroAndLastIsOne() {
        let values = [0.0, 50.0, 100.0]
        let fractions = SliderMath.stepFractions(values: values, minimum: 0.0, maximum: 100.0)
        XCTAssertEqual(fractions.first, 0.0)
        XCTAssertEqual(fractions.last,  1.0)
    }

    // MARK: - nearestStepIndex(to:among:)

    func testNearestStepIndexPicksClosest() {
        let fractions = [0.0, 0.25, 0.5, 0.75, 1.0]
        XCTAssertEqual(SliderMath.nearestStepIndex(to: 0.30, among: fractions), 1)
        XCTAssertEqual(SliderMath.nearestStepIndex(to: 0.60, among: fractions), 2)
        XCTAssertEqual(SliderMath.nearestStepIndex(to: 0.90, among: fractions), 4)
    }

    func testNearestStepIndexWithSingleElementReturnsZero() {
        XCTAssertEqual(SliderMath.nearestStepIndex(to: 0.7, among: [0.5]), 0)
    }

    func testNearestStepIndexWithEmptyArrayReturnsZero() {
        XCTAssertEqual(SliderMath.nearestStepIndex(to: 0.5, among: []), 0)
    }

    // MARK: - fraction(dragX:trackWidth:thumbSize:)

    func testDragFractionClampsToZeroForNegativeX() {
        XCTAssertEqual(SliderMath.fraction(dragX: -20, trackWidth: 300, thumbSize: 28), 0.0)
    }

    func testDragFractionClampsToOneForOvershoot() {
        XCTAssertEqual(SliderMath.fraction(dragX: 500, trackWidth: 300, thumbSize: 28), 1.0)
    }

    func testDragFractionWithZeroUsableWidthReturnsZero() {
        XCTAssertEqual(SliderMath.fraction(dragX: 14, trackWidth: 28, thumbSize: 28), 0.0)
    }

    // MARK: - value(at:minimum:maximum:)

    func testValueAtFractionZeroIsMinimum() {
        XCTAssertEqual(SliderMath.value(at: 0.0, minimum: 10.0, maximum: 100.0), 10.0, accuracy: 0.001)
    }

    func testValueAtFractionOneIsMaximum() {
        XCTAssertEqual(SliderMath.value(at: 1.0, minimum: 10.0, maximum: 100.0), 100.0, accuracy: 0.001)
    }

    func testValueAtMidpointInterpolates() {
        XCTAssertEqual(SliderMath.value(at: 0.5, minimum: 0.0, maximum: 100.0), 50.0, accuracy: 0.001)
    }

    func testValueClampsForFractionAboveOne() {
        XCTAssertEqual(SliderMath.value(at: 1.5, minimum: 0.0, maximum: 100.0), 100.0, accuracy: 0.001)
    }

    // MARK: - thumbLeadingOffset(fraction:trackWidth:thumbSize:)

    func testThumbLeadingOffsetAtZeroIsZero() {
        let offset = SliderMath.thumbLeadingOffset(fraction: 0.0, trackWidth: 300, thumbSize: 28)
        XCTAssertEqual(offset, 0.0, accuracy: 0.001)
    }

    func testThumbLeadingOffsetAtOnePositionsThumbAtRightEdge() {
        let offset = SliderMath.thumbLeadingOffset(fraction: 1.0, trackWidth: 300, thumbSize: 28)
        XCTAssertEqual(offset, 272.0, accuracy: 0.001)  // 300 - 28
    }
}
