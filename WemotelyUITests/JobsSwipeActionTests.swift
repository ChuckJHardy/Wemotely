import XCTest

class JobsSwipeActionTests: BaseUITestCase {
    let jobTitle = "Front-End Engineer - CND Growth Team"

    func testSwipeToDelete() {
        let fromAccount = (name: "All Inboxes", index: 0)
        let toAccount = (name: "Trash", index: 3)

        app.launch()

        app.startAndEndOnDashboard {
            let dashboardTable = app.tables["dashboardTableView"]

            // Record counts before changes
            let fromCountBefore = app.countInDashboardCell(table: dashboardTable, position: fromAccount.index)
            let toCountBefore = app.countInDashboardCell(table: dashboardTable, position: toAccount.index)

            // Tap "from" row
            app.cellByIndex(table: dashboardTable, index: fromAccount.index).tap()
            XCTAssert(app.isDisplayingJobs)

            // Check number of rows in table match dashboard row count
            let jobsTable = app.tables["jobsTableView"]
            let jobsTableRowsCountBefore = app.countCellsInTable(table: jobsTable)
            XCTAssertEqual(jobsTableRowsCountBefore, fromCountBefore)

            // Delete Job
            app.swipeAndDelete(table: jobsTable, label: jobTitle)

            // Cell should have been removed
            XCTAssertEqual(app.countCellsInTable(table: jobsTable), jobsTableRowsCountBefore - 1)

            // Back to Dashboard
            app.navigationBars[fromAccount.name].buttons["Dashboard"].tap()
            XCTAssert(app.isDisplayingDashboard)

            // Record counts after changes
            let fromCountAfter = app.countInDashboardCell(table: dashboardTable, position: fromAccount.index)
            let toCountAfter = app.countInDashboardCell(table: dashboardTable, position: toAccount.index)

            // Checks counts match changes
            XCTAssertEqual(fromCountBefore - 1, fromCountAfter)
            XCTAssertEqual(toCountBefore + 1, toCountAfter)

            // Tap "to" row
            app.cellByIndex(table: dashboardTable, index: toAccount.index).tap()

            // Check number of rows in table match dashboard row count
            XCTAssertEqual(app.countCellsInTable(table: jobsTable), toCountAfter)

            // Check change row is the same
            XCTAssert(jobsTable.cells.staticTexts[jobTitle].exists)

            // Back to Dashboard
            app.navigationBars[toAccount.name].buttons["Dashboard"].tap()
            XCTAssert(app.isDisplayingDashboard)
        }
    }

    func testSwipeToFavourite() {
        let fromAccount = (name: "All Inboxes", index: 0)
        let toAccount = (name: "Favourites", index: 1)

        app.launch()

        app.startAndEndOnDashboard {
            let dashboardTable = app.tables["dashboardTableView"]

            // Record counts before changes
            let fromCountBefore = app.countInDashboardCell(table: dashboardTable, position: fromAccount.index)
            let toCountBefore = app.countInDashboardCell(table: dashboardTable, position: toAccount.index)

            // Tap "from" row
            app.cellByIndex(table: dashboardTable, index: fromAccount.index).tap()
            XCTAssert(app.isDisplayingJobs)

            // Check number of rows in table match dashboard row count
            let jobsTable = app.tables["jobsTableView"]
            let jobsTableRowsCountBefore = app.countCellsInTable(table: jobsTable)
            XCTAssertEqual(jobsTableRowsCountBefore, fromCountBefore)

            // Favourite Job
            app.swipeAndFavourite(table: jobsTable, label: jobTitle)

            // Cell should have been removed
            XCTAssertEqual(app.countCellsInTable(table: jobsTable), jobsTableRowsCountBefore - 1)

            // Back to Dashboard
            app.navigationBars[fromAccount.name].buttons["Dashboard"].tap()
            XCTAssert(app.isDisplayingDashboard)

            // Record counts after changes
            let fromCountAfter = app.countInDashboardCell(table: dashboardTable, position: fromAccount.index)
            let toCountAfter = app.countInDashboardCell(table: dashboardTable, position: toAccount.index)

            // Checks counts match changes
            XCTAssertEqual(fromCountBefore - 1, fromCountAfter)
            XCTAssertEqual(toCountBefore + 1, toCountAfter)

            // Tap "to" row
            app.cellByIndex(table: dashboardTable, index: toAccount.index).tap()

            // Check number of rows in table match dashboard row count
            XCTAssertEqual(app.countCellsInTable(table: jobsTable), toCountAfter)

            // Check change row is the same
            XCTAssert(jobsTable.cells.staticTexts[jobTitle].exists)

            // Back to Dashboard
            app.navigationBars[toAccount.name].buttons["Dashboard"].tap()
            XCTAssert(app.isDisplayingDashboard)
        }
    }

    func testSwipeToUndelete() {
        let fromAccount = (name: "Trash", index: 3)
        let toAccount = (name: "All Inboxes", index: 0)

        app.launch()

        app.startAndEndOnDashboard {
            let dashboardTable = app.tables["dashboardTableView"]

            // Delete Job
            app.cellByIndex(table: dashboardTable, index: toAccount.index).tap()
            app.swipeAndDelete(table: app.tables["jobsTableView"], label: jobTitle)
            app.navigationBars[toAccount.name].buttons["Dashboard"].tap()

            // Record counts before changes
            let fromCountBefore = app.countInDashboardCell(table: dashboardTable, position: fromAccount.index)
            let toCountBefore = app.countInDashboardCell(table: dashboardTable, position: toAccount.index)

            // Tap "from" row
            app.cellByIndex(table: dashboardTable, index: fromAccount.index).tap()
            XCTAssert(app.isDisplayingJobs)

            // Check number of rows in table match dashboard row count
            let jobsTable = app.tables["jobsTableView"]
            let jobsTableRowsCountBefore = app.countCellsInTable(table: jobsTable)
            XCTAssertEqual(jobsTableRowsCountBefore, fromCountBefore)

            // Unfavourite Job
            app.swipeAndUndelete(table: jobsTable, label: jobTitle)

            // Cell should have been removed
            XCTAssertEqual(app.countCellsInTable(table: jobsTable), jobsTableRowsCountBefore - 1)

            // Back to Dashboard
            app.navigationBars[fromAccount.name].buttons["Dashboard"].tap()
            XCTAssert(app.isDisplayingDashboard)

            // Record counts after changes
            let fromCountAfter = app.countInDashboardCell(table: dashboardTable, position: fromAccount.index)
            let toCountAfter = app.countInDashboardCell(table: dashboardTable, position: toAccount.index)

            // Checks counts match changes
            XCTAssertEqual(fromCountBefore - 1, fromCountAfter)
            XCTAssertEqual(toCountBefore + 1, toCountAfter)
        }
    }

    func testSwipeToUnfavourite() {
        let fromAccount = (name: "Favourites", index: 1)
        let toAccount = (name: "All Inboxes", index: 0)

        app.launch()

        app.startAndEndOnDashboard {
            let dashboardTable = app.tables["dashboardTableView"]

            // Favourite Job
            app.cellByIndex(table: dashboardTable, index: toAccount.index).tap()
            app.swipeAndFavourite(table: app.tables["jobsTableView"], label: jobTitle)
            app.navigationBars[toAccount.name].buttons["Dashboard"].tap()

            // Record counts before changes
            let fromCountBefore = app.countInDashboardCell(table: dashboardTable, position: fromAccount.index)
            let toCountBefore = app.countInDashboardCell(table: dashboardTable, position: toAccount.index)

            // Tap "from" row
            app.cellByIndex(table: dashboardTable, index: fromAccount.index).tap()
            XCTAssert(app.isDisplayingJobs)

            // Check number of rows in table match dashboard row count
            let jobsTable = app.tables["jobsTableView"]
            let jobsTableRowsCountBefore = app.countCellsInTable(table: jobsTable)
            XCTAssertEqual(jobsTableRowsCountBefore, fromCountBefore)

            // Unfavourite Job
            app.swipeAndUnfavourite(table: jobsTable, label: jobTitle)

            // Cell should have been removed
            XCTAssertEqual(app.countCellsInTable(table: jobsTable), jobsTableRowsCountBefore - 1)

            // Back to Dashboard
            app.navigationBars[fromAccount.name].buttons["Dashboard"].tap()
            XCTAssert(app.isDisplayingDashboard)

            // Record counts after changes
            let fromCountAfter = app.countInDashboardCell(table: dashboardTable, position: fromAccount.index)
            let toCountAfter = app.countInDashboardCell(table: dashboardTable, position: toAccount.index)

            // Checks counts match changes
            XCTAssertEqual(fromCountBefore - 1, fromCountAfter)
            XCTAssertEqual(toCountBefore + 1, toCountAfter)
        }
    }
}
