import XCTest

class JobTests: BaseUITestCase {
    let accountName = "All Inboxes"
    let companyName = "Car Next Door"
    let jobTitle = "Front-End Engineer - CND Growth Team"

    func testNavigationBarTitlePrompt() {
        app.launch()

        gotoJobs()
        gotoJob()

        app.assertNavigationTitle(app: app, title: companyName)
        app.assertNavigationPrompt(app: app, title: companyName, prompt: jobTitle)
    }

    func testFavouritingJob() {
        let account = (name: "Favourites", index: 1)
        let icon = (labelBefore: "unheart", labelAfter: "heart", index: 1)

        app.launch()

        app.startAndEndOnDashboard {
            let dashboardTable = app.tables["dashboardTableView"]

            // Record counts before changes
            let favouriteCountBefore = app.countInDashboardCell(table: dashboardTable, position: account.index)

            gotoJobs()

            // Record counts before changes
            let jobsTable = app.tables["jobsTableView"]
            let jobsTableCellCountBefore = app.countCellsInTable(table: jobsTable)

            gotoJob()

            // Check Icon State
            let favouriteIcon = app.iconInToolbar(toolbar: app.toolbars.element(boundBy: 1), position: icon.index)
            XCTAssertEqual(favouriteIcon.label, icon.labelBefore)

            // Tap favourite icon
            favouriteIcon.tap()

            // Check Icon State Changed
            XCTAssertEqual(favouriteIcon.label, icon.labelAfter)

            backToJobs()

            // Cell should have been removed
            XCTAssertEqual(app.countCellsInTable(table: jobsTable), jobsTableCellCountBefore - 1)

            backToDashboard()

            // Check favourites count increase
            let favouriteCountAfter = app.countInDashboardCell(table: dashboardTable, position: account.index)
            XCTAssertEqual(favouriteCountBefore + 1, favouriteCountAfter)
        }
    }

    func testUnfavouritingJob() {
        let account = (name: "Favourites", index: 1)
        let icon = (labelBefore: "heart", labelAfter: "unheart", index: 1)

        app.launch()

        app.startAndEndOnDashboard {
            let dashboardTable = app.tables["dashboardTableView"]

            // Record counts before changes
            let favouriteCountBefore = app.countInDashboardCell(table: dashboardTable, position: account.index)

            gotoJobs()

            // Record counts before changes
            let jobsTable = app.tables["jobsTableView"]
            let jobsTableCellCountBefore = app.countCellsInTable(table: jobsTable)

            // Favourite Job using Swipe action
            app.swipeAndFavourite(table: jobsTable, label: jobTitle)

            // Cell should have been removed
            XCTAssertEqual(app.countCellsInTable(table: jobsTable), jobsTableCellCountBefore - 1)

            backToDashboard()
            gotoFavourites()

            // Record counts before changes
            let favouritesJobsTableCellCountBefore = app.countCellsInTable(table: jobsTable)

            gotoJob()

            // Check Icon State
            let favouriteIcon = app.iconInToolbar(toolbar: app.toolbars.element(boundBy: 1), position: icon.index)
            XCTAssertEqual(favouriteIcon.label, icon.labelBefore)

            // Tap favourite icon
            favouriteIcon.tap()

            // Check Icon State Changed
            XCTAssertEqual(favouriteIcon.label, icon.labelAfter)

            backToFavourites()

            // Cell should have been removed
            XCTAssertEqual(app.countCellsInTable(table: jobsTable), favouritesJobsTableCellCountBefore - 1)

            // Back to Dashboard
            app.navigationBars["Favourites"].buttons["Dashboard"].tap()
            gotoJobs()

            // Cell should have returned
            XCTAssertEqual(app.countCellsInTable(table: jobsTable), jobsTableCellCountBefore)

            backToDashboard()

            // Check favourites count unchanged
            let favouriteCountAfter = app.countInDashboardCell(table: dashboardTable, position: account.index)
            XCTAssertEqual(favouriteCountBefore, favouriteCountAfter)
        }
    }

    func testDeletingJob() {
        let account = (name: "Trash", index: 3)
        let icon = (label: "trash", index: 2)

        app.launch()

        app.startAndEndOnDashboard {
            let dashboardTable = app.tables["dashboardTableView"]

            // Record counts before changes
            let deleteCountBefore = app.countInDashboardCell(table: dashboardTable, position: account.index)

            gotoJobs()

            // Record counts before changes
            let jobsTable = app.tables["jobsTableView"]
            let jobsTableCellCountBefore = app.countCellsInTable(table: jobsTable)

            gotoJob()

            // Check Icon State
            let deleteIcon = app.iconInToolbar(toolbar: app.toolbars.element(boundBy: 1), position: icon.index)
            XCTAssertEqual(deleteIcon.label, icon.label)

            // Tap delete icon
            deleteIcon.tap()

            // Segue back to Jobs
            if app.isPhone() {
                XCTAssert(app.isDisplayingJobs)
            }

            // Cell should have been removed
            XCTAssertEqual(app.countCellsInTable(table: jobsTable), jobsTableCellCountBefore - 1)

            backToDashboard()

            // Check trash count increase
            let deleteCountAfter = app.countInDashboardCell(table: dashboardTable, position: account.index)
            XCTAssertEqual(deleteCountBefore + 1, deleteCountAfter)
        }
    }

    func testUndeletingJob() {
        let account = (name: "Trash", index: 3)
        let icon = (label: "inbox", index: 2)

        app.launch()

        app.startAndEndOnDashboard {
            let dashboardTable = app.tables["dashboardTableView"]

            // Record counts before changes
            let deleteCountBefore = app.countInDashboardCell(table: dashboardTable, position: account.index)

            gotoJobs()

            // Record counts before changes
            let jobsTable = app.tables["jobsTableView"]
            let jobsTableCellCountBefore = app.countCellsInTable(table: jobsTable)

            // Delete Job using Swipe action
            app.swipeAndDelete(table: jobsTable, label: jobTitle)

            // Cell should have been removed
            XCTAssertEqual(app.countCellsInTable(table: jobsTable), jobsTableCellCountBefore - 1)

            backToDashboard()
            gotoTrash()

            // Record counts before changes
            let deleteJobsTableCellCountBefore = app.countCellsInTable(table: jobsTable)

            gotoJob()

            // Check Icon State
            let deleteIcon = app.iconInToolbar(toolbar: app.toolbars.element(boundBy: 1), position: icon.index)
            XCTAssertEqual(deleteIcon.label, icon.label)

            // Tap delete icon
            deleteIcon.tap()

            // Segue back to Trash
            if app.isPhone() {
                XCTAssert(app.isDisplayingJobs)
            }

            // Cell should have been removed
            XCTAssertEqual(app.countCellsInTable(table: jobsTable), deleteJobsTableCellCountBefore - 1)

            // Back to Dashboard
            app.navigationBars["Trash"].buttons["Dashboard"].tap()
            gotoJobs()

            // Cell should have returned
            XCTAssertEqual(app.countCellsInTable(table: jobsTable), jobsTableCellCountBefore)

            backToDashboard()

            // Check trash count unchanged
            let deleteCountAfter = app.countInDashboardCell(table: dashboardTable, position: account.index)
            XCTAssertEqual(deleteCountBefore, deleteCountAfter)
        }
    }

    func testOpen() {
        app.launch()

        app.startAndEndOnDashboard {
            gotoJobs()
            gotoJob()

            XCTAssertTrue(app.isDisplayingJob)

            // Tap open icon
            let openIcon = app.iconInToolbar(toolbar: app.toolbars.element(boundBy: 1), position: 0)
            openIcon.tap()

            sleep(10)
            XCTAssertFalse(app.isDisplayingJob)

            app.activate()
            XCTAssertTrue(app.isDisplayingJob)

            backToJobs()
            backToDashboard()
        }
    }

    private func gotoJobs() {
        app.cellByLabel(table: app.tables["dashboardTableView"], label: accountName).tap()
        XCTAssert(app.isDisplayingJobs)
    }

    private func gotoJob() {
        app.cellByLabel(table: app.tables["jobsTableView"], label: jobTitle).tap()
        XCTAssert(app.isDisplayingJob)
    }

    private func gotoFavourites() {
        app.cellByIndex(table: app.tables["dashboardTableView"], index: 1).tap()
        XCTAssert(app.isDisplayingFavourites)
    }

    private func backToFavourites() {
        if app.isPhone() {
            app.navigationBars[companyName].buttons["Favourites"].tap()
        }
        XCTAssert(app.isDisplayingFavourites)
    }

    private func gotoTrash() {
        app.cellByIndex(table: app.tables["dashboardTableView"], index: 3).tap()
        XCTAssert(app.isDisplayingTrash)
    }

    private func backToTrash() {
        if app.isPhone() {
            app.navigationBars[companyName].buttons["Trash"].tap()
        }
        XCTAssert(app.isDisplayingTrash)
    }

    private func backToJobs() {
        if app.isPhone() {
            app.navigationBars[companyName].buttons[accountName].tap()
        }
        XCTAssert(app.isDisplayingJobs)
    }

    private func backToDashboard() {
        app.navigationBars[accountName].buttons["Dashboard"].tap()
        XCTAssert(app.isDisplayingDashboard)
    }
}
