import XCTest

class JobsRefreshTests: BaseUITestCase {
    let delay = 7

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
        let promptBefore = app.navigationBars[account.name].staticTexts.firstMatch.label

        // Pull to Refresh
        let cell = app.cellByIndex(table: jobsTable, index: 0)
        app.pullToRefresh(cell: cell)

        // Navigation prompt updates each appearance of view
        let prompt = app.navigationBars[account.name].staticTexts.firstMatch.label
        XCTAssertTrue(prompt.contains("Updated"))
        XCTAssertNotEqual(promptBefore, prompt)

        // Amount of rows should increase
        let jobsTableRowsCountAfter = app.countCellsInTable(table: jobsTable)
        XCTAssertGreaterThan(jobsTableRowsCountAfter, jobsTableRowsCountBefore)

        // Back to Dashboard
        app.navigationBars[account.name].buttons["Dashboard"].tap()
        XCTAssert(app.isDisplayingDashboard)
    }
}
