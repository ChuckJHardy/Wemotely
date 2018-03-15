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

                app.forCell(in: table, run: { (index) in
                    let cell = app.cellByIndex(table: table, index: index)
                    let switcher = app.switchInCell(cell: cell)

                    XCTAssertTrue(app.isSwitchOn(switchElement: switcher))
                    switcher.tap()
                    XCTAssertFalse(app.isSwitchOn(switchElement: switcher))
                    switcher.tap()
                })

                // Tap Edit Dashboard 'Back' Button
                app.navigationBars["Edit Dashboard"].buttons["Dashboard"].tap()

                XCTAssert(app.isDisplayingDashboard)
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
