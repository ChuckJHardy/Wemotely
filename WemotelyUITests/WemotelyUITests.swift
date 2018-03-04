import XCTest

class WemotelyUITests: XCTestCase {
    let app = XCUIApplication()
        
    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false
        app.launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testNavigatingToFilter() {
        XCTAssertTrue(app.navigationBars["Dashboard"].exists, "Failed to start on Dashboard Screen")
        
        // Tap Toolbar Filter Button
        app.toolbars.buttons["Filter"].tap()
        
        XCTAssertTrue(app.navigationBars["Filter"].exists, "Failed to Segue to the Filter Screen")
        
        // Tap Dashboard Back Button
        app.navigationBars["Filter"].buttons["Dashboard"].tap()
        
        XCTAssertTrue(app.navigationBars["Dashboard"].exists, "Failed to Segue back to Dashboard Screen")
    }
}
