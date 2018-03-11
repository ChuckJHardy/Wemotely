import XCTest

@testable import Wemotely

class SeedTests: BaseTestCase {
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testAlreadySeeded() {
        let app = App()
        app.seeded = true

        // swiftlint:disable:next force_try
        try! realm.write {
            realm.add(app, update: true)
        }

        Seed(realm: realm).call()

        XCTAssertEqual(realm.objects(App.self).count, 1)
        XCTAssertEqual(realm.objects(App.self).first?.accounts.count, 0)
    }

    func testUnseeded() {
        Seed().call()

        XCTAssertEqual(realm.objects(App.self).count, 1)
        XCTAssertEqual(realm.objects(App.self).first?.accounts.count, 6)
    }
}
