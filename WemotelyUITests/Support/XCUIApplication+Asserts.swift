import XCTest

extension XCUIApplication {
    func assertOrder(top: XCUIElement, bottom: XCUIElement) {
        XCTAssertLessThanOrEqual(top.frame.maxY, bottom.frame.minY)
    }

    func assertNavigationTitle(app: XCUIApplication, title: String) {
        XCTAssert(app.navigationBars[title].exists)
    }

    func assertNavigationPrompt(app: XCUIApplication, title: String, prompt: String) {
        XCTAssert(app.navigationBars[title].staticTexts[prompt].exists)
    }
}
