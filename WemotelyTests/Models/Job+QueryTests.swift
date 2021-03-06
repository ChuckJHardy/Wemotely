import XCTest

@testable import Wemotely

// swiftlint:disable:next type_body_length
class JobQueryTests: BaseTestCase {
    func testUnorganisedForSingleAccount() {
        XCTAssertEqual(realm.objects(Job.self).count, 0)

        let account = Account()

        let job1 = Job(value: ["guid": "1", "pubDate": Date(timeIntervalSinceNow: -1000)])
        let job2 = Job(value: ["guid": "2", "pubDate": Date(timeIntervalSinceNow: -10)])
        job1.account = account
        job2.account = account

        saveApp { (app) in
            account.jobs.append(job1)
            account.jobs.append(job2)
            app.accounts.append(account)
        }

        XCTAssertEqual(realm.objects(Job.self).count, 2)

        let row = TestFixtures.Rows.unorganisedRow(accountUUID: account.uuid)
        if let sut = Job.byRowFilter(provider: realm, row: row) {
            XCTAssertEqual(sut.count, 2)
            XCTAssertEqual(sut.first, job2)
            XCTAssertEqual(sut.last, job1)
        }
    }

    func testUnorganisedForAllAccounts() {
        XCTAssertEqual(realm.objects(Job.self).count, 0)

        let activeAccount = Account(value: ["urlKey": "A", "active": true])
        let inactiveAccount = Account(value: ["urlKey": "B", "active": false])

        let job1 = Job(value: ["guid": "1", "pubDate": Date(timeIntervalSinceNow: -1000)])
        let job2 = Job(value: ["guid": "2", "pubDate": Date(timeIntervalSinceNow: -100)])
        let job3 = Job(value: ["guid": "3", "pubDate": Date(timeIntervalSinceNow: -10)])
        job1.account = activeAccount
        job2.account = activeAccount
        job3.account = inactiveAccount

        saveApp { (app) in
            activeAccount.jobs.append(job1)
            activeAccount.jobs.append(job2)
            inactiveAccount.jobs.append(job3)
            app.accounts.append(activeAccount)
            app.accounts.append(inactiveAccount)
        }

        XCTAssertEqual(realm.objects(Job.self).count, 3)

        let row = TestFixtures.Rows.unorganisedRow()
        if let sut = Job.byRowFilter(provider: realm, row: row) {
            XCTAssertEqual(sut.count, 2)
            XCTAssertEqual(sut.first, job2)
            XCTAssertEqual(sut.last, job1)
        }
    }

    func testInboxForSingleAccount() {
        XCTAssertEqual(realm.objects(Job.self).count, 0)

        let account = Account()

        let job1 = Job(value: ["guid": "1", "pubDate": Date(timeIntervalSinceNow: -1000)])
        let job2 = Job(value: ["guid": "2", "pubDate": Date(timeIntervalSinceNow: -10)])
        job1.account = account
        job2.account = account

        saveApp { (app) in
            account.jobs.append(job1)
            account.jobs.append(job2)
            app.accounts.append(account)
        }

        XCTAssertEqual(realm.objects(Job.self).count, 2)

        let row = TestFixtures.Rows.standardRow(accountUUID: account.uuid)
        if let sut = Job.byRowFilter(provider: realm, row: row) {
            XCTAssertEqual(sut.count, 2)
            XCTAssertEqual(sut.first, job2)
            XCTAssertEqual(sut.last, job1)
        }
    }

    func testfavouritedForSingleAccount() {
        XCTAssertEqual(realm.objects(Job.self).count, 0)

        let account = Account()

        let job1 = Job(value: ["guid": "1", "favourite": true, "pubDate": Date(timeIntervalSinceNow: -1000)])
        let job2 = Job(value: ["guid": "2", "favourite": true, "pubDate": Date(timeIntervalSinceNow: -10)])
        let job3 = Job(value: ["guid": "3", "favourite": true, "trash": true])
        let job4 = Job(value: ["guid": "4", "favourite": false, "trash": true])
        let job5 = Job(value: ["guid": "5", "favourite": false, "trash": false])
        job1.account = account
        job2.account = account
        job3.account = account
        job4.account = account
        job5.account = account

        saveApp { (app) in
            account.jobs.append(job1)
            account.jobs.append(job2)
            account.jobs.append(job3)
            account.jobs.append(job4)
            account.jobs.append(job5)
            app.accounts.append(account)
        }

        XCTAssertEqual(realm.objects(Job.self).count, 5)

        let row = TestFixtures.Rows.favouritedRow(accountUUID: account.uuid)
        if let sut = Job.byRowFilter(provider: realm, row: row) {
            XCTAssertEqual(sut.count, 2)
            XCTAssertEqual(sut.first, job2)
            XCTAssertEqual(sut.last, job1)
        }
    }

    func testfavouritedForAllAccount() {
        XCTAssertEqual(realm.objects(Job.self).count, 0)

        let activeAccount = Account(value: ["urlKey": "A", "active": true])
        let inactiveAccount = Account(value: ["urlKey": "B", "active": false])

        let job1 = Job(value: ["guid": "1", "favourite": true, "pubDate": Date(timeIntervalSinceNow: -1000)])
        let job2 = Job(value: ["guid": "2", "favourite": true, "pubDate": Date(timeIntervalSinceNow: -10)])
        let job3 = Job(value: ["guid": "3", "favourite": true, "pubDate": Date(timeIntervalSinceNow: -10)])
        let job4 = Job(value: ["guid": "4", "favourite": false, "trash": true])
        let job5 = Job(value: ["guid": "5", "favourite": false, "trash": false])
        job1.account = activeAccount
        job2.account = activeAccount
        job3.account = inactiveAccount
        job4.account = activeAccount
        job5.account = activeAccount

        saveApp { (app) in
            activeAccount.jobs.append(job1)
            activeAccount.jobs.append(job2)
            inactiveAccount.jobs.append(job3)
            activeAccount.jobs.append(job4)
            activeAccount.jobs.append(job5)
            app.accounts.append(activeAccount)
            app.accounts.append(inactiveAccount)
        }

        XCTAssertEqual(realm.objects(Job.self).count, 5)

        let row = TestFixtures.Rows.favouritedRow()
        if let sut = Job.byRowFilter(provider: realm, row: row) {
            XCTAssertEqual(sut.count, 2)
            XCTAssertEqual(sut.first, job2)
            XCTAssertEqual(sut.last, job1)
        }
    }

    func testUnreadForSingleAccount() {
        XCTAssertEqual(realm.objects(Job.self).count, 0)

        let account = Account()

        let job1 = Job(value: ["guid": "1", "read": false, "pubDate": Date(timeIntervalSinceNow: -1000)])
        let job2 = Job(value: ["guid": "2", "read": false, "pubDate": Date(timeIntervalSinceNow: -1)])
        let job3 = Job(value: ["guid": "3", "read": false, "trash": true, "pubDate": Date(timeIntervalSinceNow: -10)])
        let job4 = Job(
            value: ["guid": "4", "read": false, "favourite": true, "pubDate": Date(timeIntervalSinceNow: -100)]
        )
        let job5 = Job(value: ["guid": "5", "read": true, "trash": false])
        job1.account = account
        job2.account = account
        job3.account = account
        job4.account = account
        job5.account = account

        saveApp { (app) in
            account.jobs.append(job1)
            account.jobs.append(job2)
            account.jobs.append(job3)
            account.jobs.append(job4)
            account.jobs.append(job5)
            app.accounts.append(account)
        }

        XCTAssertEqual(realm.objects(Job.self).count, 5)

        let row = TestFixtures.Rows.unreadRow(accountUUID: account.uuid)
        if let sut = Job.byRowFilter(provider: realm, row: row) {
            XCTAssertEqual(sut.count, 4)
            XCTAssertEqual(sut.first, job2)
            XCTAssertEqual(sut.last, job1)
        }
    }

    func testUnreadForAllAccount() {
        XCTAssertEqual(realm.objects(Job.self).count, 0)

        let activeAccount = Account(value: ["urlKey": "A", "active": true])
        let inactiveAccount = Account(value: ["urlKey": "B", "active": false])

        let job1 = Job(value: ["guid": "1", "read": false, "pubDate": Date(timeIntervalSinceNow: -1000)])
        let job2 = Job(value: ["guid": "2", "read": false, "pubDate": Date(timeIntervalSinceNow: -1)])
        let job3 = Job(value: ["guid": "3", "read": false, "trash": true, "pubDate": Date(timeIntervalSinceNow: -10)])
        let job4 = Job(
            value: ["guid": "4", "read": false, "favourite": true, "pubDate": Date(timeIntervalSinceNow: -100)]
        )
        let job5 = Job(value: ["guid": "5", "read": true, "trash": false])
        job1.account = activeAccount
        job2.account = activeAccount
        job3.account = activeAccount
        job4.account = inactiveAccount
        job5.account = activeAccount

        saveApp { (app) in
            activeAccount.jobs.append(job1)
            activeAccount.jobs.append(job2)
            activeAccount.jobs.append(job3)
            inactiveAccount.jobs.append(job4)
            activeAccount.jobs.append(job5)
            app.accounts.append(activeAccount)
            app.accounts.append(inactiveAccount)
        }

        XCTAssertEqual(realm.objects(Job.self).count, 5)

        let row = TestFixtures.Rows.unreadRow()
        if let sut = Job.byRowFilter(provider: realm, row: row) {
            XCTAssertEqual(sut.count, 3)
            XCTAssertEqual(sut.first, job2)
            XCTAssertEqual(sut.last, job1)
        }
    }

    func testTrashedForSingleAccount() {
        XCTAssertEqual(realm.objects(Job.self).count, 0)

        let account = Account()

        let job1 = Job(value: ["guid": "1", "trash": true, "pubDate": Date(timeIntervalSinceNow: -1000)])
        let job2 = Job(value: ["guid": "2", "trash": true, "pubDate": Date(timeIntervalSinceNow: -1)])
        let job3 = Job(value: ["guid": "3", "trash": true, "read": true, "pubDate": Date(timeIntervalSinceNow: -10)])
        let job4 = Job(
            value: ["guid": "4", "trash": true, "favourite": true, "pubDate": Date(timeIntervalSinceNow: -100)]
        )
        let job5 = Job(value: ["guid": "5", "trash": false, "read": false])
        job1.account = account
        job2.account = account
        job3.account = account
        job4.account = account
        job5.account = account

        saveApp { (app) in
            account.jobs.append(job1)
            account.jobs.append(job2)
            account.jobs.append(job3)
            account.jobs.append(job4)
            account.jobs.append(job5)
            app.accounts.append(account)
        }

        XCTAssertEqual(realm.objects(Job.self).count, 5)

        let row = TestFixtures.Rows.trashedRow(accountUUID: account.uuid)
        if let sut = Job.byRowFilter(provider: realm, row: row) {
            XCTAssertEqual(sut.count, 4)
            XCTAssertEqual(sut.first, job2)
            XCTAssertEqual(sut.last, job1)
        }
    }

    func testTrashedForAllAccount() {
        XCTAssertEqual(realm.objects(Job.self).count, 0)

        let activeAccount = Account(value: ["urlKey": "A", "active": true])
        let inactiveAccount = Account(value: ["urlKey": "B", "active": false])

        let job1 = Job(value: ["guid": "1", "trash": true, "pubDate": Date(timeIntervalSinceNow: -1000)])
        let job2 = Job(value: ["guid": "2", "trash": true, "pubDate": Date(timeIntervalSinceNow: -1)])
        let job3 = Job(value: ["guid": "3", "trash": true, "read": true, "pubDate": Date(timeIntervalSinceNow: -10)])
        let job4 = Job(
            value: ["guid": "4", "trash": true, "favourite": true, "pubDate": Date(timeIntervalSinceNow: -100)]
        )
        let job5 = Job(value: ["guid": "5", "trash": false, "read": false])

        job1.account = activeAccount
        job2.account = activeAccount
        job3.account = activeAccount
        job4.account = inactiveAccount
        job5.account = activeAccount

        activeAccount.jobs.append(job1)
        activeAccount.jobs.append(job2)
        activeAccount.jobs.append(job3)
        inactiveAccount.jobs.append(job4)
        activeAccount.jobs.append(job5)

        saveApp { (app) in
            app.accounts.append(activeAccount)
            app.accounts.append(inactiveAccount)
        }

        XCTAssertEqual(realm.objects(Job.self).count, 5)

        let row = TestFixtures.Rows.trashedRow()
        if let sut = Job.byRowFilter(provider: realm, row: row) {
            XCTAssertEqual(sut.count, 3)
            XCTAssertEqual(sut.first, job2)
            XCTAssertEqual(sut.last, job1)
        }
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
