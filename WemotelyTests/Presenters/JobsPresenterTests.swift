import XCTest

@testable import Wemotely

class JobsPresenterTests: BaseTestCase {
    // MARK: - navigationPrompt

    func testNavigationPrompt() {
        let presenter = JobsPresenter()
        let sut = presenter.navigationPrompt()

        XCTAssertEqual(sut, "")
    }

    func testNavigationPromptWithDate() {
        let presenter = JobsPresenter(locale: locale)
        let testDate = Date(timeInterval: 1000, since: Date())
        let sut = presenter.navigationPrompt(date: testDate)

        XCTAssertEqual(sut, "Updated 16 minutes ago")
    }

    func testNavigationPromptWithDateForDiffernetLocal() {
        let presenter = JobsPresenter(locale: Locale(identifier: "fr_FR"))
        let testDate = Date(timeIntervalSince1970: 1000)
        let sut = presenter.navigationPrompt(date: testDate)

        XCTAssertEqual(sut, "Updated 48 years ago")
    }
}
