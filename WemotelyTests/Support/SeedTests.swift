import XCTest

@testable import Wemotely

class SeedTests: BaseTestCase {
    var beforeTriggered: Bool!
    var afterTriggered: Bool!
    var skippedTriggered: Bool!

    override func setUp() {
        super.setUp()

        beforeTriggered = false
        afterTriggered = false
        skippedTriggered = false
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

        Seed(realm: realm).call(before: {
            beforeTriggered = true
        }, after: {
            afterTriggered = true
        }, skipped: {
            skippedTriggered = true
        })

        XCTAssertEqual(realm.objects(App.self).count, 1)
        XCTAssertEqual(realm.objects(App.self).first?.accounts.count, 0)

        XCTAssertFalse(beforeTriggered)
        XCTAssertFalse(afterTriggered)
        XCTAssertTrue(skippedTriggered)
    }

    func testUnseeded() {
        Seed(realm: realm).call(before: {
            beforeTriggered = true
        }, after: {
            afterTriggered = true
        }, skipped: {
            skippedTriggered = true
        })

        XCTAssertEqual(realm.objects(App.self).count, 1)
        XCTAssertEqual(realm.objects(App.self).first?.accounts.count, 6)

        XCTAssertTrue(beforeTriggered)
        XCTAssertTrue(afterTriggered)
        XCTAssertFalse(skippedTriggered)
    }
}
