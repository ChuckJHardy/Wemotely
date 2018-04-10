import XCTest

class DashboardTests: BaseUITestCase {
    let delay = 10

    func testInitialLaunch() {
        app.delayBackgroundProcessBy(duration: String(delay))

        app.launch()

        let dashboardTable = app.tables["dashboardTableView"]

        XCTAssertEqual(app.simpleCountCellsInTable(table: dashboardTable), 0)
        sleep(UInt32(delay))
        XCTAssertEqual(app.countCellsInTable(table: dashboardTable), 34)
    }

    func testSubsequentLaunch() {
        // Conduct initial application load
        app.launch()
        let dashboardTable = app.tables["dashboardTableView"]
        let cell = app.cellByIndex(table: dashboardTable, index: 0)
        XCTAssertTrue(cell.waitForExistence(timeout: TimeInterval(delay)))

        XCUIDevice.shared.press(.home)
        app.activate()

        app.delayBackgroundProcessBy(duration: String(delay))

        // Table should be shown on load
        XCTAssertEqual(app.countCellsInTable(table: dashboardTable), 34)
    }
}
