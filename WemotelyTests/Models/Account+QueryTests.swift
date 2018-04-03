import XCTest
import RealmSwift

@testable import Wemotely

class AccountQueryTests: BaseTestCase {
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testByUUIDReturningAccount() {
        let realm = RealmProvider.realm()
        let app = App()

        let account1 = Account(value: ["urlKey": "A"])
        let account2 = Account(value: ["urlKey": "B"])

        app.accounts.append(account1)
        app.accounts.append(account2)

        XCTAssertEqual(realm.objects(Account.self).count, 0)

        // swiftlint:disable:next force_try
        try! realm.write {
            realm.add(app)
        }

        XCTAssertEqual(realm.objects(Account.self).count, 2)

        let sut = Account.byUUID(provider: realm, uuid: account1.uuid)

        XCTAssertEqual(sut?.uuid, account1.uuid)
    }

    func testByUUIDReturningAccounts() {
        let realm = RealmProvider.realm()
        let app = App()

        let account1 = Account(value: ["urlKey": "A"])
        let account2 = Account(value: ["urlKey": "B"])
        let account3 = Account(value: ["urlKey": "C"])

        app.accounts.append(account1)
        app.accounts.append(account2)
        app.accounts.append(account3)

        XCTAssertEqual(realm.objects(Account.self).count, 0)

        // swiftlint:disable:next force_try
        try! realm.write {
            realm.add(app)
        }

        XCTAssertEqual(realm.objects(Account.self).count, 3)

        let sut = Account.byUUID(provider: realm, uuids: [account1.uuid, account2.uuid])

        XCTAssertEqual(sut?.first?.uuid, account1.uuid)
        XCTAssertEqual(sut?.last?.uuid, account2.uuid)
        XCTAssertFalse((sut?.contains(account3))!)
    }

    func testRefreshable() {
        let realm = RealmProvider.realm()
        let app = App()

        let account1 = Account(value: ["urlKey": "A"])
        let account2 = Account(value: ["urlKey": "B"])

        app.accounts.append(account1)
        app.accounts.append(account2)

        XCTAssertEqual(realm.objects(Account.self).count, 0)

        // swiftlint:disable:next force_try
        try! realm.write {
            realm.add(app)
        }

        XCTAssertEqual(realm.objects(Account.self).count, 2)

        let sut = Account.refreshable(provider: realm, uuid: account1.uuid)

        XCTAssertEqual(sut?.count, 1)
        XCTAssertEqual(sut?.first?.uuid, account1.uuid)
    }

    func testRefreshableWithoutUUID() {
        activeSortedShared(sut: Account.refreshable(provider: realm)!)
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
        activeSortedShared(sut: Account.activeSorted(provider: realm))
    }

    private func activeSortedShared(sut: Results<Account>) {
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
        XCTAssertEqual(sut.count, 2)
        XCTAssertEqual(sut.first, account2)
        XCTAssertEqual(sut.last, account1)
    }
}
