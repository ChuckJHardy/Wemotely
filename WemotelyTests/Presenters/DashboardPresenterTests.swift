import XCTest

@testable import Wemotely

class DashboardPresenterTests: BaseTestCase {
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testE2E() {
        Seed(realm: realm).call(before: {
            // Nothing
        }, after: {
            // Nothing
        }, skipped: {
            // Nothing
        })

        let accounts = Account.activeSorted(provider: realm)
        let sections = DashboardPresenter(accounts: accounts).present()

        XCTAssertEqual(sections.count, 7)
        XCTAssertEqual(sections.first?.heading, "")
        XCTAssertEqual(sections.first?.rows.count, 10)
    }
}
