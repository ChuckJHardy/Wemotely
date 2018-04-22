import XCTest

class JobsTests: BaseUITestCase {
    func testOpen() {
        let accountName = "All Inboxes"
        app.launch()

        app.cellByLabel(table: app.tables["dashboardTableView"], label: accountName).tap()
        XCTAssertTrue(app.isDisplayingJobs)

        // Tap open icon
        let openIcon = app.iconInToolbar(toolbar: app.toolbars["Toolbar"], position: 0)
        openIcon.tap()

        app.activate()
        XCTAssertTrue(app.isDisplayingJobs)
    }
}
