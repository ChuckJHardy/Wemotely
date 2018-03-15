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
                gotoDashboardEdit()

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
                backToDashboard()

                XCTAssert(app.isDisplayingDashboard)
            }
        }
    }

    func testDisablingAccount() {
        app.launch()

        app.runWithSupportedOrientations {
            startAndEndOnDashboard {
                // Tap Navigation Bar 'Edit' Button
                gotoDashboardEdit()

                XCTAssert(app.isDisplayingEditDashboard)

                // iPad should still show list of Jobs
                if app.isPad() {
                    XCTAssert(app.isDisplayingJob)
                }

                let editDashboardTable = app.tables["editDashboardTableView"]

                app.forCell(in: editDashboardTable, run: { (index) in
                    let cell = app.cellByIndex(table: editDashboardTable, index: index)
                    let label = app.labelInCell(cell: cell)
                    let switcher = app.switchInCell(cell: cell)

                    XCTAssertTrue(app.isSwitchOn(switchElement: switcher))

                    switcher.tap()

                    backToDashboard()
                    XCTAssert(app.isDisplayingDashboard)

                    let dashboardTable = app.tables["dashboardTableView"]
                    // Dashboard Account Cell is Hidden
                    XCTAssertFalse(dashboardTable.cells.staticTexts[label].exists)
                    // Dashboard Section is Hidden
                    XCTAssertFalse(dashboardTable.otherElements.staticTexts[label].exists)

                    // Tap Navigation Bar 'Edit' Button
                    gotoDashboardEdit()
                    XCTAssert(app.isDisplayingEditDashboard)

                    switcher.tap()
                    XCTAssertTrue(app.isSwitchOn(switchElement: switcher))

                    backToDashboard()
                    XCTAssert(app.isDisplayingDashboard)

                    // Dashboard Account Cell is Shown
                    XCTAssertTrue(dashboardTable.cells.staticTexts[label].exists)
                    // Dashboard Section is Shown
                    XCTAssertTrue(dashboardTable.otherElements.staticTexts[label].exists)

                    gotoDashboardEdit()
                    XCTAssert(app.isDisplayingEditDashboard)
                })

                backToDashboard()
                XCTAssert(app.isDisplayingDashboard)
            }
        }
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

    private func gotoDashboardEdit() {
        app.navigationBars["Dashboard"].buttons["Edit"].tap()
    }

    private func backToDashboard() {
        app.navigationBars["Edit Dashboard"].buttons["Dashboard"].tap()
    }
}
