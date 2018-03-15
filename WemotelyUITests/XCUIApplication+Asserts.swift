import XCTest

extension XCUIApplication {
    func assertOrder(top: XCUIElement, bottom: XCUIElement) {
        XCTAssertLessThanOrEqual(top.frame.maxY, bottom.frame.minY)
    }
}
