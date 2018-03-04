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
        
        for orientation in app.supportedOrientations {
            XCUIDevice.shared.orientation = orientation
            
            XCTAssertTrue(app.isDisplayingDashboard, "Failed to start on Dashboard Screen")
            
            // Tap Toolbar Filter Button
            app.toolbars.buttons["Filter"].tap()
            
            XCTAssertTrue(app.isDisplayingFilter, "Failed to Segue to the Filter Screen")
            
            // Tap Dashboard Back Button
            app.navigationBars["Filter"].buttons["Dashboard"].tap()
            
            XCTAssertTrue(app.isDisplayingDashboard, "Failed to Segue back to Dashboard Screen")
        }
    }
}
