import XCTest

class SegueUITests: XCTestCase {
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

    func testDetailViewExpandCollapse() {
        app.launch()

        if app.isPad() {
            XCTAssert(app.isDisplayingDashboard)
            XCTAssert(app.isDisplayingJob)

            let jobNavigationBar = app.navigationBars["Job"]
            jobNavigationBar.buttons["Switch to full screen mode"].tap()

            XCTAssertFalse(app.isDisplayingDashboard)
            XCTAssert(app.isDisplayingJob)

            jobNavigationBar.buttons["Master"].tap()

            XCTAssert(app.isDisplayingDashboard)
            XCTAssert(app.isDisplayingJob)
        }
    }

    func testNavigatingToEdit() {
        app.launch()

        app.runWithSupportedOrientations {
            startAndEndOnDashboard {
                // Tap Navigation Bar 'Edit' Button
                app.navigationBars["Dashboard"].buttons["Edit"].tap()

                XCTAssert(app.isDisplayingEditDashboard)

                // Tap Dashboard 'Back' Button
                app.navigationBars["Edit Dashboard"].buttons["Dashboard"].tap()
            }
        }
    }

    func testNavigatingToSettings() {
        app.launch()

        app.runWithSupportedOrientations {
            startAndEndOnDashboard {
                // Tap Navigation Bar 'Settings' Button
                app.navigationBars["Dashboard"].buttons["Settings"].tap()

                XCTAssert(app.isDisplayingSettings)

                // Tap Dashboard 'Back' Button
                app.navigationBars["Settings"].buttons["Dashboard"].tap()
            }
        }
    }

    func testNavigatingToSettingsNavigationOptions() {
        let settingsOption = "Notification Options"

        app.launch()

        app.runWithSupportedOrientations {
            startAndEndOnDashboard {
                // Tap Navigation Bar 'Settings' Button
                app.navigationBars["Dashboard"].buttons["Settings"].tap()

                XCTAssert(app.isDisplayingSettings)

                app.tables["settingsTableView"].cells.staticTexts[settingsOption].tap()

                // iPad should still show list of Settings
                if app.isPad() {
                    XCTAssert(app.isDisplayingSettings)
                } else {
                    XCTAssertFalse(app.isDisplayingSettings)
                }

                XCTAssert(app.navigationBars[settingsOption].exists)

                // Tap Dashboard 'Back' Button
                if app.isPhone() {
                    app.navigationBars[settingsOption].buttons["Settings"].tap()
                }
                app.navigationBars["Settings"].buttons["Dashboard"].tap()

                // 'Job' Screen should be shown
                if app.isPad() {
                    XCTAssert(app.isDisplayingJob)
                }
            }
        }
    }

    func testNavigatingToJobs() {
        app.launch()

        app.runWithSupportedOrientations {
            startAndEndOnDashboard {
                // Tap first cell in 'Dashboard' table
                app.tables["dashboardTableView"].cells.staticTexts["All Inboxes"].tap()

                XCTAssert(app.isDisplayingJobs)

                // Tap Dashboard 'Back' Button
                app.navigationBars["Jobs"].buttons["Dashboard"].tap()
            }
        }
    }

    func testSelectingAJob() {
        let jobTitle = "Full Stack Dev with Rails Focus"

        app.launch()

        app.runWithSupportedOrientations {
            startAndEndOnDashboard {
                // Tap first cell in 'Dashboard' table
                app.tables["dashboardTableView"].cells.staticTexts["All Inboxes"].tap()
                app.tables["jobsTableView"].cells.staticTexts[jobTitle].tap()

                // iPad should still show list of Jobs
                if app.isPad() {
                    XCTAssert(app.isDisplayingJobs)
                }

                XCTAssert(app.navigationBars[jobTitle].exists)

                // Tap Dashboard 'Back' Button
                if app.isPhone() {
                    app.navigationBars[jobTitle].buttons["Jobs"].tap()
                }
                app.navigationBars["Jobs"].buttons["Dashboard"].tap()

                // Previously selected Job should sill be shown on iPad
                if app.isPad() {
                    XCTAssert(app.navigationBars[jobTitle].exists)
                }
            }
        }
    }

    private func startAndEndOnDashboard(block: () -> Void) {
        XCTAssertTrue(app.isDisplayingDashboard, "Failed to start on Dashboard Screen")
        block()
        XCTAssertTrue(app.isDisplayingDashboard, "Failed to Segue back to 'Dashboard' Screen")
    }
}
