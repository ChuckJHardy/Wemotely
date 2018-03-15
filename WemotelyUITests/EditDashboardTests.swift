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

    func testAccountActivation() {
        app.launch()

        app.runWithSupportedOrientations {
            startAndEndOnDashboard {
                gotoDashboardEdit()

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

                    let dashboardTable = app.tables["dashboardTableView"]
                    // Dashboard Account Cell is Hidden
                    XCTAssertFalse(dashboardTable.cells.staticTexts[label].exists)
                    // Dashboard Section is Hidden
                    XCTAssertFalse(dashboardTable.otherElements.staticTexts[label].exists)

                    gotoDashboardEdit()

                    switcher.tap()
                    XCTAssertTrue(app.isSwitchOn(switchElement: switcher))

                    backToDashboard()

                    // Dashboard Account Cell is Shown
                    XCTAssertTrue(dashboardTable.cells.staticTexts[label].exists)
                    // Dashboard Section is Shown
                    XCTAssertTrue(dashboardTable.otherElements.staticTexts[label].exists)

                    gotoDashboardEdit()
                })

                backToDashboard()
            }
        }
    }

    func testOrderingAccounts() {
        app.launch()

        app.runWithSupportedOrientations {
            startAndEndOnDashboard {
                gotoDashboardEdit()

                // iPad should still show list of Jobs
                if app.isPad() {
                    XCTAssert(app.isDisplayingJob)
                }

                let editDashboardTable = app.tables["editDashboardTableView"]

                app.navigationBars["Edit Dashboard"].buttons["Reorder"].tap()

                let programmingCell = editDashboardTable.buttons["Reorder Programming"]
                let copywritingCell = editDashboardTable.buttons["Reorder Copywriting"]

                XCTAssertLessThanOrEqual(programmingCell.frame.maxY, copywritingCell.frame.minY)

                copywritingCell.press(forDuration: 0.5, thenDragTo: programmingCell)

                XCTAssertLessThanOrEqual(copywritingCell.frame.maxY, programmingCell.frame.minY)

                app.navigationBars["Edit Dashboard"].buttons["Done"].tap()

                backToDashboard()

                // Do Check on Dashboard

                gotoDashboardEdit()

                app.navigationBars["Edit Dashboard"].buttons["Reorder"].tap()

                programmingCell.press(forDuration: 0.5, thenDragTo: copywritingCell)

                XCTAssertLessThanOrEqual(programmingCell.frame.maxY, copywritingCell.frame.minY)

                backToDashboard()
            }
        }
    }

    private func startAndEndOnDashboard(block: () -> Void) {
        XCTAssertTrue(app.isDisplayingDashboard, "Failed to start on Dashboard Screen")
        block()
        XCTAssertTrue(app.isDisplayingDashboard, "Failed to Segue back to 'Dashboard' Screen")
    }

    private func gotoDashboardEdit() {
        app.navigationBars["Dashboard"].buttons["Edit"].tap()
        XCTAssert(app.isDisplayingEditDashboard)
    }

    private func backToDashboard() {
        app.navigationBars["Edit Dashboard"].buttons["Dashboard"].tap()
        XCTAssert(app.isDisplayingDashboard)
    }
}
