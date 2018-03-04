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
            }
        }
    }
    
    private func assertToolbarHidden() {
        XCTAssertFalse(app.toolbars.buttons["Filter"].exists, "Toolbar 'Filter' Button available")
        XCTAssertFalse(app.toolbars.buttons["Settings"].exists, "Toolbar 'Settings' Button available")
    }
    
    private func startAndEndOnDashboard(block: () -> Void) {
        XCTAssertTrue(app.isDisplayingDashboard, "Failed to start on Dashboard Screen")
        block()
        XCTAssertTrue(app.isDisplayingDashboard, "Failed to Segue back to 'Dashboard' Screen")
    }
}
