import XCTest

class JobsRefreshTests: BaseTestCase {
    let delay = 3

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    // MARK: - Tests

    func testPullToRefresh() {
        let account = (name: "All Inboxes", index: 0)

        app.delayBackgroundProcessBy(duration: String(delay))

        app.launch()

        let dashboardTable = app.tables["dashboardTableView"]
        XCTAssertTrue(dashboardTable.waitForExistence(timeout: TimeInterval(10)))

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
