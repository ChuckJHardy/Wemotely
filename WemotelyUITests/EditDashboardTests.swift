import XCTest

class EditDashboardTests: XCTestCase {
    var app: XCUIApplication!

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

    func testDefaultState() {
        app.launch()

        app.runWithSupportedOrientations {
            startAndEndOnDashboard {
                // Tap Navigation Bar 'Edit' Button
                app.navigationBars["Dashboard"].buttons["Edit"].tap()

                XCTAssert(app.isDisplayingEditDashboard)

                // iPad should still show list of Jobs
                if app.isPad() {
                    XCTAssert(app.isDisplayingJob)
                }

                let table = app.tables["editDashboardTableView"]

                XCTAssertEqual(table.cells.count, 6)

                var elementLabels = [String]()
                for i in 0..<table.cells.count {
                    elementLabels.append(table.cells.element(boundBy: i).staticTexts.element(boundBy: 0).label)
                }

                for label in elementLabels {
                    let switcher = table.switches[label]

                    XCTAssertTrue(switcher.value.debugDescription == "Optional(1)")
                    switcher.tap()
                    XCTAssertTrue(switcher.value.debugDescription == "Optional(0)")
                    switcher.tap()
                }

                // Tap Edit Dashboard 'Back' Button
                app.navigationBars["Edit Dashboard"].buttons["Dashboard"].tap()
            }
        }
    }

    func testDisablingAccount() {

    }

    func testEnablingAccount() {

    }

    func testOrderingAccounts() {

    }

    private func startAndEndOnDashboard(block: () -> Void) {
        XCTAssertTrue(app.isDisplayingDashboard, "Failed to start on Dashboard Screen")
        block()
        XCTAssertTrue(app.isDisplayingDashboard, "Failed to Segue back to 'Dashboard' Screen")
    }
}
