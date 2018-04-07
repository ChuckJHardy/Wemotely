import XCTest

class EditDashboardTests: BaseUITestCase {
    func testAccountActivation() {
        app.launch()

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

    func testOrderingAccounts() {
        app.launch()

        startAndEndOnDashboard {
            gotoDashboardEdit()

            // iPad should still show list of Jobs
            if app.isPad() {
                XCTAssert(app.isDisplayingJob)
            }

            let editDashboardTable = app.tables["editDashboardTableView"]
            let navigationBar = app.navigationBars["Edit Dashboard"]
            let reorderButton = navigationBar.buttons["Reorder"]
            let reorderDoneButton = navigationBar.buttons["Done"]

            reorderButton.tap()

            let programmingCell = editDashboardTable.buttons["Reorder Programming"]
            let copywritingCell = editDashboardTable.buttons["Reorder Copywriting"]

            app.assertOrder(top: programmingCell, bottom: copywritingCell)

            copywritingCell.press(forDuration: 0.5, thenDragTo: programmingCell)

            app.assertOrder(top: copywritingCell, bottom: programmingCell)

            reorderDoneButton.tap()

            backToDashboard()

            // Do Check on Dashboard
            let dashboardTable = app.tables["dashboardTableView"]
            let dashboardProgrammingCell = dashboardTable.cells.staticTexts["Programming"]
            let dashboardProgrammingSection = dashboardTable.otherElements.staticTexts["Programming"]
            let dashboardCopywritingCell = dashboardTable.cells.staticTexts["Copywriting"]
            let dashboardCopywritingSection = dashboardTable.otherElements.staticTexts["Copywriting"]

            app.assertOrder(top: dashboardCopywritingCell, bottom: dashboardProgrammingCell)
            app.assertOrder(top: dashboardCopywritingSection, bottom: dashboardProgrammingSection)

            gotoDashboardEdit()

            reorderButton.tap()

            programmingCell.press(forDuration: 0.5, thenDragTo: copywritingCell)

            app.assertOrder(top: programmingCell, bottom: copywritingCell)

            backToDashboard()

            app.assertOrder(top: dashboardProgrammingCell, bottom: dashboardCopywritingCell)
            app.assertOrder(top: dashboardProgrammingSection, bottom: dashboardCopywritingSection)
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
