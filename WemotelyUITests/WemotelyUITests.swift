import XCTest

class WemotelyUITests: XCTestCase {
    var app: XCUIApplication!
        
    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false
        
        app = XCUIApplication()
        app.resetOrientation()

        // We send a command line argument to our app, to enable it to reset its state
        app.launchArguments.append("--uitesting")
    }
    
    override func tearDown() {
        super.tearDown()
        app.resetOrientation()
    }
    
    // MARK: - Tests
    
    func testNavigatingToFilter() {
        app.launch()
        
        app.runWithSupportedOrientations {
            startAndEndOnDashboard {
                // Tap Toolbar 'Filter' Button
                app.toolbars.buttons["Filter"].tap()
                
                XCTAssert(app.isDisplayingFilter)
                
                assertToolbarHidden()
                
                // Tap Dashboard 'Back' Button
                app.navigationBars["Filter"].buttons["Dashboard"].tap()
                
                assertToolbarShown()
            }
        }
    }
    
    func testNavigatingToSettings() {
        app.launch()
        
        app.runWithSupportedOrientations {
            startAndEndOnDashboard {
                // Tap Toolbar 'Settings' Button
                app.toolbars.buttons["Settings"].tap()
                
                XCTAssert(app.isDisplayingSettings)
                
                assertToolbarHidden()
                
                // Tap Dashboard 'Back' Button
                app.navigationBars["Settings"].buttons["Dashboard"].tap()
                
                assertToolbarShown()
            }
        }
    }
    
    func testNavigatingToJobs() {
        app.launch()
        
        app.runWithSupportedOrientations {
            startAndEndOnDashboard {
                // Tap first cell in 'Dashboard' table
                app.tables["dashboardTableView"]/*@START_MENU_TOKEN@*/.cells.staticTexts["Inbox"]/*[[".cells.staticTexts[\"Inbox\"]",".staticTexts[\"Inbox\"]"],[[[-1,1],[-1,0]]],[1]]@END_MENU_TOKEN@*/.tap()
                
                XCTAssert(app.isDisplayingJobs)
                
                assertToolbarHidden()
                
                // Tap Dashboard 'Back' Button
                app.navigationBars["Jobs"].buttons["Dashboard"].tap()
                
                assertToolbarShown()
            }
        }
    }
    
    func testSelectingAJob() {
        let jobTitle = "Engineer 1"
        
        app.launch()
        
        app.runWithSupportedOrientations {
            startAndEndOnDashboard {
                // Tap first cell in 'Dashboard' table
                app.tables["dashboardTableView"]/*@START_MENU_TOKEN@*/.cells.staticTexts["Inbox"]/*[[".cells.staticTexts[\"Inbox\"]",".staticTexts[\"Inbox\"]"],[[[-1,1],[-1,0]]],[1]]@END_MENU_TOKEN@*/.tap()
                app.tables["jobsTableView"].cells.staticTexts[jobTitle].tap()
                
                // iPad should still show list of Jobs
                if app.isPad() {
                    XCTAssert(app.isDisplayingJobs)
                }
                
                XCTAssert(app.navigationBars[jobTitle].exists)
                
                assertToolbarHidden()
                
                // Tap Dashboard 'Back' Button
                if app.isPhone() {
                    app.navigationBars[jobTitle].buttons["Jobs"].tap()
                }
                app.navigationBars["Jobs"].buttons["Dashboard"].tap()

                // Previously selected Job should sill be shown on iPad
                if app.isPad() {
                    XCTAssert(app.navigationBars[jobTitle].exists)
                }
                
                assertToolbarShown()
            }
        }
    }
    
    private func assertToolbarHidden() {
        XCTAssertFalse(app.toolbars.buttons["Filter"].exists, "Toolbar 'Filter' Button available")
        XCTAssertFalse(app.toolbars.buttons["Settings"].exists, "Toolbar 'Settings' Button available")
    }
    
    private func assertToolbarShown() {
        XCTAssertTrue(app.toolbars.buttons["Filter"].exists, "Toolbar 'Filter' Button not available")
        XCTAssertTrue(app.toolbars.buttons["Settings"].exists, "Toolbar 'Settings' Button not available")
    }
    
    private func startAndEndOnDashboard(block: () -> Void) {
        XCTAssertTrue(app.isDisplayingDashboard, "Failed to start on Dashboard Screen")
        block()
        XCTAssertTrue(app.isDisplayingDashboard, "Failed to Segue back to 'Dashboard' Screen")
    }
}
