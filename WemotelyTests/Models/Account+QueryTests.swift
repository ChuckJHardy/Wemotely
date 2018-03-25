import XCTest

@testable import Wemotely

class AccountQueryTests: BaseTestCase {
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testAllSorted() {
        let realm = RealmProvider.realm()
        let app = App()

        let account1 = Account(value: ["urlKey": "A", "active": true, "order": 2])
        let account2 = Account(value: ["urlKey": "B", "active": true, "order": 1])
        let account3 = Account(value: ["urlKey": "C", "active": false, "order": 3])

        app.accounts.append(account1)
        app.accounts.append(account2)
        app.accounts.append(account3)

        XCTAssertEqual(realm.objects(Account.self).count, 0)

        // swiftlint:disable:next force_try
        try! realm.write {
            realm.add(app)
        }

        XCTAssertEqual(realm.objects(Account.self).count, 3)

        let sut = Account.allSorted(provider: realm)

        XCTAssertEqual(sut.count, 3)
        XCTAssertEqual(sut.first, account2)
        XCTAssertEqual(sut.last, account3)
    }

    func testActiveSorted() {
        let realm = RealmProvider.realm()
        let app = App()

        let account1 = Account(value: ["urlKey": "A", "active": true, "order": 2])
        let account2 = Account(value: ["urlKey": "B", "active": true, "order": 1])
        let account3 = Account(value: ["urlKey": "C", "active": false, "order": 3])

        app.accounts.append(account1)
        app.accounts.append(account2)
        app.accounts.append(account3)

        XCTAssertEqual(realm.objects(Account.self).count, 0)

        // swiftlint:disable:next force_try
        try! realm.write {
            realm.add(app)
        }

        XCTAssertEqual(realm.objects(Account.self).count, 3)

        let sut = Account.activeSorted(provider: realm)

        XCTAssertEqual(sut.count, 2)
        XCTAssertEqual(sut.first, account2)
        XCTAssertEqual(sut.last, account1)
    }
}
