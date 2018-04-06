import XCTest

@testable import Wemotely

class JobsPresenterTests: BaseTestCase {
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    // MARK: - pullToRefreshMessage

    func testPullToRefreshMessage() {
        let presenter = JobsPresenter()
        let sut = presenter.pullToRefreshMessage()

        XCTAssertEqual(sut, "Pull to refresh")
    }

    func testPullToRefreshMessageWithDate() {
        let presenter = JobsPresenter(locale: locale)
        let testDate = Date(timeIntervalSince1970: 1000)
        let sut = presenter.pullToRefreshMessage(date: testDate)

        XCTAssertEqual(sut, "Last updated Jan 1, 1970 at 1:16 AM")
    }

    func testPullToRefreshMessageWithDateForDiffernetLocal() {
        let presenter = JobsPresenter(locale: Locale(identifier: "fr_FR"))
        let testDate = Date(timeIntervalSince1970: 1000)
        let sut = presenter.pullToRefreshMessage(date: testDate)

        XCTAssertEqual(sut, "Last updated 1 janv. 1970 à 01:16")
    }
}
