import XCTest

@testable import Wemotely

class BasePresenterTests: BaseTestCase {
    func testDateAsString() {
        let presenter = BasePresenter()
        let sut = presenter.dateAsString(prefix: "Updated")

        XCTAssertEqual(sut, "")
    }

    func testDateAsStringWithDate() {
        let presenter = BasePresenter(locale: locale)
        let testDate = Date(timeInterval: 1000, since: Date())
        let sut = presenter.dateAsString(prefix: "Updated", date: testDate)

        XCTAssertEqual(sut, "Updated 16 minutes ago")
    }

    func testDateAsStringWithDateForDiffernetLocal() {
        let presenter = BasePresenter(locale: Locale(identifier: "fr_FR"))
        let testDate = Date(timeIntervalSince1970: 1000)
        let sut = presenter.dateAsString(prefix: "Currently", date: testDate)

        XCTAssertEqual(sut, "Currently 48 years ago")
    }
}
