import XCTest

class SegueUITests: BaseUITestCase {
    func testDetailViewExpandCollapse() {
        app.launch()

        if app.isPad() {
            XCTAssert(app.isDisplayingDashboard)
            XCTAssert(app.isDisplayingJob)

            let jobNavigationBar = app.navigationBars["Wemotely.JobView"]
            jobNavigationBar.buttons["Switch to full screen mode"].tap()

            XCTAssertFalse(app.isDisplayingDashboard)
            XCTAssert(app.isDisplayingJob)

            jobNavigationBar.buttons[" "].tap()

            XCTAssert(app.isDisplayingDashboard)
            XCTAssert(app.isDisplayingJob)
        }
    }

    func testNavigatingToEdit() {
        app.launch()

        app.runWithSupportedOrientations {
            app.startAndEndOnDashboard {
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
            app.startAndEndOnDashboard {
                // Tap Navigation Bar 'Settings' Button
                app.navigationBars["Dashboard"].buttons["settings"].tap()

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
            app.startAndEndOnDashboard {
                // Tap Navigation Bar 'Settings' Button
                app.navigationBars["Dashboard"].buttons["settings"].tap()

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
        let accountName = "All Inboxes"

        app.launch()

        app.runWithSupportedOrientations {
            app.startAndEndOnDashboard {
                // Tap first cell in 'Dashboard' table
                app.tables["dashboardTableView"].cells.staticTexts[accountName].tap()

                XCTAssert(app.isDisplayingJobs)

                // Tap Dashboard 'Back' Button
                app.navigationBars[accountName].buttons["Dashboard"].tap()
            }
        }
    }

    func testSelectingAJobSharedAccount() {
        selectingAJob("All Inboxes")
    }

    func testSelectingAJobSpecificAccount() {
        selectingAJob("Programming")
    }

    private func selectingAJob(_ accountName: String) {
        let companyName = "Car Next Door"
        let jobTitle = "Front-End Engineer - CND Growth Team"

        app.launch()

        app.startAndEndOnDashboard {
            // Tap first cell in 'Dashboard' table
            app.tables["dashboardTableView"].cells.staticTexts[accountName].tap()
            app.cellByLabel(table: app.tables["jobsTableView"], label: jobTitle).tap()

            // iPad should still show list of Jobs
            if app.isPad() {
                XCTAssert(app.isDisplayingJobs)
            }

            // Company name shown in Navigation Bar
            XCTAssert(app.navigationBars[companyName].exists)
            // Job title shown in Navigation Bar as prompt
            XCTAssert(app.navigationBars[companyName].staticTexts[jobTitle].exists)

            // Tap Dashboard 'Back' Button
            if app.isPhone() {
                app.navigationBars[companyName].buttons[accountName].tap()
            }
            app.navigationBars[accountName].buttons["Dashboard"].tap()

            // Previously selected Job should sill be shown on iPad
            if app.isPad() {
                sleep(3)
                print(app.navigationBars)
                XCTAssert(app.navigationBars[companyName].exists)
            }
        }
    }
}
