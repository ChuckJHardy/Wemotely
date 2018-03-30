import XCTest

class JobTests: XCTestCase {
    var app: XCUIApplication!

    let accountName = "All Inboxes"
    let companyName = "Car Next Door"
    let jobTitle = "Front-End Engineer - CND Growth Team"

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

    func testNavigationBarTitlePrompt() {
        app.launch()

        app.runWithSupportedOrientations {
            gotoJob()

            app.assertNavigationTitle(app: app, title: companyName)
            app.assertNavigationPrompt(app: app, title: companyName, prompt: jobTitle)

            backToDashboard()
        }
    }

    private func gotoJob() {
        app.tables["dashboardTableView"].cells.staticTexts[accountName].tap()
        app.cellByLabel(table: app.tables["jobsTableView"], label: jobTitle).tap()
        XCTAssert(app.isDisplayingJob)
    }

    private func backToDashboard() {
        if app.isPhone() {
            app.navigationBars[companyName].buttons[accountName].tap()
        }
        app.navigationBars[accountName].buttons["Dashboard"].tap()

        XCTAssert(app.isDisplayingDashboard)
    }
}