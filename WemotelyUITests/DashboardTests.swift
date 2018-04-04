import XCTest

class DashboardTests: XCTestCase {
    var app: XCUIApplication!

    let delay = 3

    override func setUp() {
        super.setUp()

        continueAfterFailure = false

        app = XCUIApplication()
        app.resetOrientation()

        // Enable it to reset its state
        app.launchArguments.append("--uitesting")
    }

    override func tearDown() {
        super.tearDown()
        app.resetOrientation()
    }

    // MARK: - Tests

    func testInitialLaunch() {
        app.delayBackgroundProcessBy(duration: String(delay))

        app.launch()

        let dashboardTable = app.tables["dashboardTableView"]

        // Table should be hidden on load
        XCTAssertFalse(dashboardTable.exists)

        // Loading items should be show on load
        XCTAssertTrue(app.staticTexts["loadingMessage"].exists)
        XCTAssertTrue(app.activityIndicators["loadingIndicator"].exists)

        // Table should be show after load
        XCTAssertTrue(dashboardTable.waitForExistence(timeout: TimeInterval(delay)))

        // Loading items should be hidden after load
        XCTAssertFalse(app.staticTexts["loadingMessage"].exists)
        XCTAssertFalse(app.activityIndicators["loadingIndicator"].exists)
    }

    func testSubsequentLaunch() {
        // Conduct initial application load
        app.launch()
        let dashboardTable = app.tables["dashboardTableView"]
        XCTAssertTrue(dashboardTable.waitForExistence(timeout: TimeInterval(delay)))

        XCUIDevice.shared.press(.home)
        app.activate()

        app.delayBackgroundProcessBy(duration: String(delay))

        // Table should be shown on load
        XCTAssertTrue(dashboardTable.exists)

        // Loading items should be hidden on load
        XCTAssertFalse(app.staticTexts["loadingMessage"].exists)
        XCTAssertFalse(app.activityIndicators["loadingIndicator"].exists)
    }
}
