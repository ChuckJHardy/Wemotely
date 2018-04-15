import XCTest

@testable import Wemotely

class JobPresenterTests: BaseTestCase {
    func testPublishedAt() {
        let presenter = JobPresenter(locale: locale)
        let testDate = Date(timeInterval: 1000, since: Date())
        let sut = presenter.publishedAt(date: testDate)

        XCTAssertEqual(sut, "Published 16 minutes ago")
    }
}
