import XCTest

final class CustomizableSliderUITests: XCTestCase {

    private var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
    }

    // MARK: - App launch

    func testNavigationTitleIsVisible() {
        XCTAssertTrue(app.navigationBars["Sliders"].exists)
    }

    func testThemeButtonExistsInToolbar() {
        XCTAssertTrue(app.buttons["Theme"].exists)
    }

    // MARK: - Section headers

    func testLoanAmountSectionIsVisible() {
        XCTAssertTrue(app.staticTexts["Loan Amount"].exists)
    }

    func testVolumeSectionIsVisible() {
        XCTAssertTrue(app.staticTexts["Volume"].exists)
    }

    func testRatingSectionIsVisible() {
        XCTAssertTrue(app.staticTexts["Rating"].exists)
    }

    func testTemperatureSectionIsVisible() {
        XCTAssertTrue(app.staticTexts["Temperature"].exists)
    }

    // MARK: - Configuration sheet

    func testThemeButtonOpensConfigurationSheet() {
        app.buttons["Theme"].tap()
        XCTAssertTrue(app.navigationBars["Configuration"].waitForExistence(timeout: 2))
    }

    func testConfigurationSheetHasDragIndicatorToggle() {
        app.buttons["Theme"].tap()
        XCTAssertTrue(app.switches["Drag Indicator"].waitForExistence(timeout: 2))
    }

    func testConfigurationSheetHasBoundaryLabelsToggle() {
        app.buttons["Theme"].tap()
        XCTAssertTrue(app.switches["Boundary Labels Only"].waitForExistence(timeout: 2))
    }

    func testConfigurationSheetShowsAllPresets() {
        app.buttons["Theme"].tap()
        _ = app.navigationBars["Configuration"].waitForExistence(timeout: 2)
        XCTAssertTrue(app.staticTexts["Default"].exists)
        XCTAssertTrue(app.staticTexts["Ocean"].exists)
        XCTAssertTrue(app.staticTexts["Sunset"].exists)
        XCTAssertTrue(app.staticTexts["Minimal"].exists)
    }

    func testDoneButtonDismissesConfigurationSheet() {
        app.buttons["Theme"].tap()
        _ = app.navigationBars["Configuration"].waitForExistence(timeout: 2)
        app.buttons["Done"].tap()
        XCTAssertTrue(app.navigationBars["Sliders"].waitForExistence(timeout: 2))
    }

    // MARK: - Toggle interactions

    func testDragIndicatorToggleIsOnByDefault() {
        app.buttons["Theme"].tap()
        let toggle = app.switches["Drag Indicator"]
        _ = toggle.waitForExistence(timeout: 2)
        XCTAssertEqual(toggle.value as? String, "1")
    }

    func testBoundaryLabelsToggleIsOffByDefault() {
        app.buttons["Theme"].tap()
        let toggle = app.switches["Boundary Labels Only"]
        _ = toggle.waitForExistence(timeout: 2)
        XCTAssertEqual(toggle.value as? String, "0")
    }

    func testTogglingDragIndicatorChangesItsState() {
        app.buttons["Theme"].tap()
        let toggle = app.switches["Drag Indicator"]
        _ = toggle.waitForExistence(timeout: 2)
        toggle.tap()
        XCTAssertEqual(toggle.value as? String, "0")
    }

    func testTogglingBoundaryLabelsChangesItsState() {
        app.buttons["Theme"].tap()
        let toggle = app.switches["Boundary Labels Only"]
        _ = toggle.waitForExistence(timeout: 2)
        toggle.tap()
        XCTAssertEqual(toggle.value as? String, "1")
    }

    // MARK: - Preset selection

    func testSelectingOceanPresetChecksIt() {
        app.buttons["Theme"].tap()
        _ = app.navigationBars["Configuration"].waitForExistence(timeout: 2)
        app.staticTexts["Ocean"].tap()
        XCTAssertTrue(app.images["checkmark"].exists)
    }

    func testSwitchingPresetMovesCheckmark() {
        app.buttons["Theme"].tap()
        _ = app.navigationBars["Configuration"].waitForExistence(timeout: 2)
        app.staticTexts["Ocean"].tap()
        app.staticTexts["Sunset"].tap()
        XCTAssertTrue(app.images["checkmark"].exists)
    }
}
