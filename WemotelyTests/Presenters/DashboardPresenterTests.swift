import XCTest

@testable import Wemotely

class DashboardPresenterTests: XCTestCase {
    let realm = RealmProvider.realm()

    override func setUp() {
        super.setUp()

        try! realm.write { () -> Void in
            realm.deleteAll()
        }
    }

    override func tearDown() {
        super.tearDown()
    }

    func testE2E() {
        Seed(realm: realm).call()

        let accounts = Account.activeSorted(provider: realm)
        let sections = DashboardPresenter(accounts: accounts).present()

        XCTAssertEqual(sections.count, 7)
        XCTAssertEqual(sections.first?.heading, "")
        XCTAssertEqual(sections.first?.rows.count, 10)
    }
}
