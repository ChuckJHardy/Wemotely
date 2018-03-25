import XCTest

class JobsSwipeActionTests: XCTestCase {
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

    func testSwipeToDelete() {
        let accountName = "All Inboxes"
        let jobTitle = "Front-End Engineer - CND Growth Team"

        app.launch()

        app.runWithSupportedOrientations {
            app.startAndEndOnDashboard {
                let dashboardTable = app.tables["dashboardTableView"]

                // GoTo Account
                dashboardTable.cells.staticTexts[accountName].tap()

                XCTAssert(app.isDisplayingJobs)

                let jobsTable = app.tables["jobsTableView"]
                let jobsTableRowsCountBefore = jobsTable.cells.count

                app.swipeAndDelete(table: jobsTable, label: jobTitle)

                // Cell should have been removed
                XCTAssertEqual(jobsTable.cells.count, jobsTableRowsCountBefore - 1)

                // Back to Dashboard
                app.navigationBars[accountName].buttons["Dashboard"].tap()
            }
        }
    }

    func testDashboardCounts() {
        let accountName = "All Inboxes"
        let jobTitle = "Front-End Engineer - CND Growth Team"

        app.launch()

        app.runWithSupportedOrientations {
            app.startAndEndOnDashboard {
                let dashboardTable = app.tables["dashboardTableView"]

                // Record Counts
                let fromCountBefore = app.countInDashboardCell(table: dashboardTable, position: 0)
                let toCountBefore = app.countInDashboardCell(table: dashboardTable, position: 3)

                // GoTo Account
                dashboardTable.cells.staticTexts[accountName].tap()

                XCTAssert(app.isDisplayingJobs)

                let jobsTable = app.tables["jobsTableView"]
                XCTAssertEqual(jobsTable.cells.count, fromCountBefore)

                app.swipeAndDelete(table: jobsTable, label: jobTitle)

                // Back to Dashboard
                app.navigationBars[accountName].buttons["Dashboard"].tap()

                // Check Counts
                let fromCountAfter = app.countInDashboardCell(table: dashboardTable, position: 0)
                let toCountAfter = app.countInDashboardCell(table: dashboardTable, position: 3)

                XCTAssertEqual(fromCountBefore - 1, fromCountAfter)
                XCTAssertEqual(toCountBefore + 1, toCountAfter)

                // GoTo Trash
                app.cellByIndex(table: dashboardTable, index: 3).tap()
                XCTAssertEqual(jobsTable.cells.count, toCountAfter)
                XCTAssert(jobsTable.cells.staticTexts[jobTitle].exists)

                // Go Back to Dashboard
                app.navigationBars["Trash"].buttons["Dashboard"].tap()
            }
        }
    }
}
