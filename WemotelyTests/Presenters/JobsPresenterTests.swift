import XCTest

@testable import Wemotely

class JobsPresenterTests: BaseTestCase {
    func testNavigationPrompt() {
        let presenter = JobsPresenter(locale: locale)
        let testDate = Date(timeInterval: 1000, since: Date())
        let sut = presenter.navigationPrompt(date: testDate)

        XCTAssertEqual(sut, "Updated 16 minutes ago")
    }
}
