import XCTest

class JobsRefreshTests: XCTestCase {
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
        let account = (name: "All Inboxes", index: 0)

        app.launch()

        app.startAndEndOnDashboard {
            let dashboardTable = app.tables["dashboardTableView"]

            // Tap "from" row
            app.cellByIndex(table: dashboardTable, index: account.index).tap()
            XCTAssert(app.isDisplayingJobs)

            // Check number of rows in table match dashboard row count
            let jobsTable = app.tables["jobsTableView"]
            let jobsTableRowsCountBefore = app.countCellsInTable(table: jobsTable)

            // Pull to Refresh
            let cell = app.cellByIndex(table: jobsTable, index: 0)
            app.pullToRefresh(cell: cell)

            // Amount of rows should increase
            let jobsTableRowsCountAfter = app.countCellsInTable(table: jobsTable)
            XCTAssertGreaterThan(jobsTableRowsCountAfter, jobsTableRowsCountBefore)

            // Back to Dashboard
            app.navigationBars[account.name].buttons["Dashboard"].tap()
            XCTAssert(app.isDisplayingDashboard)
        }
    }
}
