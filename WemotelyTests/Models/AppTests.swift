import XCTest

@testable import Wemotely

class AppTests: BaseTestCase {
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testDefaults() {
        let app = App()

        XCTAssertEqual(app.seeded, false)
        XCTAssertEqual(app.accounts.count, 0)
    }

    func testUUID() {
        let app1 = App()
        let app2 = App()

        XCTAssertEqual(app1.uuid.count, NSUUID().uuidString.count)
        XCTAssertNotEqual(app1.uuid, app2.uuid)
    }

    func testPrimaryKey() {
        XCTAssertEqual(App.primaryKey(), "uuid")
    }

    func testCreatingAccount() {
        let realm = RealmProvider.realm()

        let app = App()

        app.seeded = true

        app.accounts.append(Account())
        app.accounts.append(Account())

        XCTAssertEqual(realm.objects(App.self).count, 0)

        // swiftlint:disable:next force_try
        try! realm.write {
            realm.add(app, update: true)
        }

        XCTAssertEqual(realm.objects(App.self).count, 1)

        let findApp = realm.objects(App.self).first

        XCTAssertEqual(findApp?.seeded, true)
        XCTAssertEqual(findApp?.accounts.count, 2)
    }
}
