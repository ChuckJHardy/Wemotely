import XCTest
import RealmSwift

@testable import Wemotely

class AccountQueryTests: BaseTestCase {
    func testByUUIDReturningAccount() {
        XCTAssertEqual(realm.objects(Account.self).count, 0)

        let account1 = TestFixtures.Accounts.simple("A")
        let account2 = TestFixtures.Accounts.simple("B")

        saveApp { (app) in
            app.accounts.append(account1)
            app.accounts.append(account2)
        }

        XCTAssertEqual(realm.objects(Account.self).count, 2)

        let sut = Account.byUUID(provider: realm, uuid: account1.uuid)

        XCTAssertEqual(sut?.uuid, account1.uuid)
    }

    func testByUUIDReturningAccounts() {
        XCTAssertEqual(realm.objects(Account.self).count, 0)

        let account1 = TestFixtures.Accounts.simple("A")
        let account2 = TestFixtures.Accounts.simple("B")
        let account3 = TestFixtures.Accounts.simple("C")

        saveApp { (app) in
            app.accounts.append(account1)
            app.accounts.append(account2)
            app.accounts.append(account3)
        }

        XCTAssertEqual(realm.objects(Account.self).count, 3)

        let sut = Account.byUUID(provider: realm, uuids: [account1.uuid, account2.uuid])

        XCTAssertEqual(sut?.first?.uuid, account1.uuid)
        XCTAssertEqual(sut?.last?.uuid, account2.uuid)
        XCTAssertFalse((sut?.contains(account3))!)
    }

    func testRefreshable() {
        XCTAssertEqual(realm.objects(Account.self).count, 0)

        let account1 = TestFixtures.Accounts.simple("A")
        let account2 = TestFixtures.Accounts.simple("B")

        saveApp { (app) in
            app.accounts.append(account1)
            app.accounts.append(account2)
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
        XCTAssertEqual(realm.objects(Account.self).count, 0)

        let account1 = TestFixtures.Accounts.simple("A", active: true, order: 2)
        let account2 = TestFixtures.Accounts.simple("B", active: true, order: 1)
        let account3 = TestFixtures.Accounts.simple("C", active: false, order: 3)

        saveApp { (app) in
            app.accounts.append(account1)
            app.accounts.append(account2)
            app.accounts.append(account3)
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

    func testOldest() {
        XCTAssertEqual(realm.objects(Account.self).count, 0)

        let account1 = TestFixtures.Accounts.updated("A", updatedAt: Date(timeInterval: -3000, since: Date()))
        let account2 = TestFixtures.Accounts.updated("B", updatedAt: Date(timeInterval: -2000, since: Date()))
        let account3 = TestFixtures.Accounts.updated("C", updatedAt: Date(timeInterval: -1000, since: Date()))
        let account4 = TestFixtures.Accounts.simple("D")

        saveApp { (app) in
            app.accounts.append(account1)
            app.accounts.append(account2)
            app.accounts.append(account3)
            app.accounts.append(account4)
        }

        let accounts = realm.objects(Account.self)
        XCTAssertEqual(accounts.count, 4)

        let sut = Account.oldest(provider: realm, accounts: accounts)

        XCTAssertEqual(sut, account1)
    }

    private func activeSortedShared(sut: Results<Account>) {
        XCTAssertEqual(realm.objects(Account.self).count, 0)

        let account1 = TestFixtures.Accounts.simple("A", active: true, order: 2)
        let account2 = TestFixtures.Accounts.simple("B", active: true, order: 1)
        let account3 = TestFixtures.Accounts.simple("C", active: false, order: 3)

        saveApp { (app) in
            app.accounts.append(account1)
            app.accounts.append(account2)
            app.accounts.append(account3)
        }

        XCTAssertEqual(realm.objects(Account.self).count, 3)
        XCTAssertEqual(sut.count, 2)
        XCTAssertEqual(sut.first, account2)
        XCTAssertEqual(sut.last, account1)
    }

    private func saveApp(bulder: (_ app: App) -> Void) {
        let app = App()

        bulder(app)

        do {
            try realm.write {
                realm.add(app)
            }
        } catch let err {
            logger.error("Failed to Save App", err)
        }
    }
}
