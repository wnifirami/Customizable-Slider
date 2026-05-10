import XCTest
@testable import CustomizableSlider

@MainActor
final class SliderViewModelTests: XCTestCase {

    // MARK: - Initial state

    func testInitialIsDraggingIsFalse() {
        let viewModel = SliderViewModel()
        XCTAssertFalse(viewModel.isDragging)
    }

    // MARK: - State transitions

    func testSettingIsDraggingToTrue() {
        let viewModel = SliderViewModel()
        viewModel.isDragging = true
        XCTAssertTrue(viewModel.isDragging)
    }

    func testSettingIsDraggingBackToFalse() {
        let viewModel = SliderViewModel()
        viewModel.isDragging = true
        viewModel.isDragging = false
        XCTAssertFalse(viewModel.isDragging)
    }
}
