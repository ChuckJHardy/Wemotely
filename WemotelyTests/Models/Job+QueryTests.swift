import XCTest

@testable import Wemotely

// swiftlint:disable:next type_body_length
class JobQueryTests: BaseTestCase {
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testUnorganisedForSingleAccount() {
        let app = App()
        let account = Account()

        let job1 = Job(value: ["pubDate": Date(timeIntervalSinceNow: 1000)])
        let job2 = Job(value: ["pubDate": Date(timeIntervalSinceNow: 10)])
        job1.account = account
        job2.account = account

        account.jobs.append(job1)
        account.jobs.append(job2)
        app.accounts.append(account)

        XCTAssertEqual(realm.objects(Job.self).count, 0)

        // swiftlint:disable:next force_try
        try! realm.write {
            realm.add(app)
        }

        XCTAssertEqual(realm.objects(Job.self).count, 2)

        let row = Row(
            filter: Filter.unorganised,
            title: "",
            icon: "",
            moveable: false,
            showTitleAsPrompt: false,
            accountUUID: account.uuid
        )

        if let sut = Job.byRowFilter(provider: realm, row: row) {
            XCTAssertEqual(sut.count, 2)
            XCTAssertEqual(sut.first, job2)
            XCTAssertEqual(sut.last, job1)
        }
    }

    func testUnorganisedForAllAccounts() {
        let app = App()
        let activeAccount = Account(value: ["urlKey": "A", "active": true])
        let inactiveAccount = Account(value: ["urlKey": "B", "active": false])

        let job1 = Job(value: ["pubDate": Date(timeIntervalSinceNow: 1000)])
        let job2 = Job(value: ["pubDate": Date(timeIntervalSinceNow: 100)])
        let job3 = Job(value: ["pubDate": Date(timeIntervalSinceNow: 10)])
        job1.account = activeAccount
        job2.account = activeAccount
        job3.account = inactiveAccount

        activeAccount.jobs.append(job1)
        activeAccount.jobs.append(job2)
        inactiveAccount.jobs.append(job3)
        app.accounts.append(activeAccount)
        app.accounts.append(inactiveAccount)

        XCTAssertEqual(realm.objects(Job.self).count, 0)

        // swiftlint:disable:next force_try
        try! realm.write {
            realm.add(app)
        }

        XCTAssertEqual(realm.objects(Job.self).count, 3)

        let row = Row(
            filter: Filter.unorganised,
            title: "",
            icon: "",
            moveable: false,
            showTitleAsPrompt: false,
            accountUUID: nil
        )

        if let sut = Job.byRowFilter(provider: realm, row: row) {
            XCTAssertEqual(sut.count, 2)
            XCTAssertEqual(sut.first, job2)
            XCTAssertEqual(sut.last, job1)
        }
    }

    func testInboxForSingleAccount() {
        let app = App()
        let account = Account()

        let job1 = Job(value: ["pubDate": Date(timeIntervalSinceNow: 1000)])
        let job2 = Job(value: ["pubDate": Date(timeIntervalSinceNow: 10)])
        job1.account = account
        job2.account = account

        account.jobs.append(job1)
        account.jobs.append(job2)
        app.accounts.append(account)

        XCTAssertEqual(realm.objects(Job.self).count, 0)

        // swiftlint:disable:next force_try
        try! realm.write {
            realm.add(app)
        }

        XCTAssertEqual(realm.objects(Job.self).count, 2)

        let row = Row(
            filter: Filter.inbox,
            title: "",
            icon: "",
            moveable: false,
            showTitleAsPrompt: false,
            accountUUID: account.uuid
        )

        if let sut = Job.byRowFilter(provider: realm, row: row) {
            XCTAssertEqual(sut.count, 2)
            XCTAssertEqual(sut.first, job2)
            XCTAssertEqual(sut.last, job1)
        }
    }

    func testfavouritedForSingleAccount() {
        let app = App()
        let account = Account()

        let job1 = Job(value: ["favourite": true, "pubDate": Date(timeIntervalSinceNow: 1000)])
        let job2 = Job(value: ["favourite": true, "pubDate": Date(timeIntervalSinceNow: 10)])
        let job3 = Job(value: ["favourite": true, "trash": true])
        let job4 = Job(value: ["favourite": false, "trash": true])
        let job5 = Job(value: ["favourite": false, "trash": false])
        job1.account = account
        job2.account = account
        job3.account = account
        job4.account = account
        job5.account = account

        account.jobs.append(job1)
        account.jobs.append(job2)
        account.jobs.append(job3)
        account.jobs.append(job4)
        account.jobs.append(job5)
        app.accounts.append(account)

        XCTAssertEqual(realm.objects(Job.self).count, 0)

        // swiftlint:disable:next force_try
        try! realm.write {
            realm.add(app)
        }

        XCTAssertEqual(realm.objects(Job.self).count, 5)

        let row = Row(
            filter: Filter.favourites,
            title: "",
            icon: "",
            moveable: false,
            showTitleAsPrompt: false,
            accountUUID: account.uuid
        )

        if let sut = Job.byRowFilter(provider: realm, row: row) {
            XCTAssertEqual(sut.count, 2)
            XCTAssertEqual(sut.first, job2)
            XCTAssertEqual(sut.last, job1)
        }
    }

    func testfavouritedForAllAccount() {
        let app = App()
        let activeAccount = Account(value: ["urlKey": "A", "active": true])
        let inactiveAccount = Account(value: ["urlKey": "B", "active": false])

        let job1 = Job(value: ["favourite": true, "pubDate": Date(timeIntervalSinceNow: 1000)])
        let job2 = Job(value: ["favourite": true, "pubDate": Date(timeIntervalSinceNow: 10)])
        let job3 = Job(value: ["favourite": true, "pubDate": Date(timeIntervalSinceNow: 10)])
        let job4 = Job(value: ["favourite": false, "trash": true])
        let job5 = Job(value: ["favourite": false, "trash": false])
        job1.account = activeAccount
        job2.account = activeAccount
        job3.account = inactiveAccount
        job4.account = activeAccount
        job5.account = activeAccount

        activeAccount.jobs.append(job1)
        activeAccount.jobs.append(job2)
        inactiveAccount.jobs.append(job3)
        activeAccount.jobs.append(job4)
        activeAccount.jobs.append(job5)
        app.accounts.append(activeAccount)
        app.accounts.append(inactiveAccount)

        XCTAssertEqual(realm.objects(Job.self).count, 0)

        // swiftlint:disable:next force_try
        try! realm.write {
            realm.add(app)
        }

        XCTAssertEqual(realm.objects(Job.self).count, 5)

        let row = Row(
            filter: Filter.favourites,
            title: "",
            icon: "",
            moveable: false,
            showTitleAsPrompt: false,
            accountUUID: nil
        )

        if let sut = Job.byRowFilter(provider: realm, row: row) {
            XCTAssertEqual(sut.count, 2)
            XCTAssertEqual(sut.first, job2)
            XCTAssertEqual(sut.last, job1)
        }
    }

    func testUnreadForSingleAccount() {
        let app = App()
        let account = Account()

        let job1 = Job(value: ["read": false, "pubDate": Date(timeIntervalSinceNow: 1000)])
        let job2 = Job(value: ["read": false, "pubDate": Date(timeIntervalSinceNow: 1)])
        let job3 = Job(value: ["read": false, "trash": true, "pubDate": Date(timeIntervalSinceNow: 10)])
        let job4 = Job(value: ["read": false, "favourite": true, "pubDate": Date(timeIntervalSinceNow: 100)])
        let job5 = Job(value: ["read": true, "trash": false])
        job1.account = account
        job2.account = account
        job3.account = account
        job4.account = account
        job5.account = account

        account.jobs.append(job1)
        account.jobs.append(job2)
        account.jobs.append(job3)
        account.jobs.append(job4)
        account.jobs.append(job5)
        app.accounts.append(account)

        XCTAssertEqual(realm.objects(Job.self).count, 0)

        // swiftlint:disable:next force_try
        try! realm.write {
            realm.add(app)
        }

        XCTAssertEqual(realm.objects(Job.self).count, 5)

        let row = Row(
            filter: Filter.unread,
            title: "",
            icon: "",
            moveable: false,
            showTitleAsPrompt: false,
            accountUUID: account.uuid
        )

        if let sut = Job.byRowFilter(provider: realm, row: row) {
            XCTAssertEqual(sut.count, 4)
            XCTAssertEqual(sut.first, job2)
            XCTAssertEqual(sut.last, job1)
        }
    }

    func testUnreadForAllAccount() {
        let app = App()
        let activeAccount = Account(value: ["urlKey": "A", "active": true])
        let inactiveAccount = Account(value: ["urlKey": "B", "active": false])

        let job1 = Job(value: ["read": false, "pubDate": Date(timeIntervalSinceNow: 1000)])
        let job2 = Job(value: ["read": false, "pubDate": Date(timeIntervalSinceNow: 1)])
        let job3 = Job(value: ["read": false, "trash": true, "pubDate": Date(timeIntervalSinceNow: 10)])
        let job4 = Job(value: ["read": false, "favourite": true, "pubDate": Date(timeIntervalSinceNow: 100)])
        let job5 = Job(value: ["read": true, "trash": false])
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
        app.accounts.append(activeAccount)
        app.accounts.append(inactiveAccount)

        XCTAssertEqual(realm.objects(Job.self).count, 0)

        // swiftlint:disable:next force_try
        try! realm.write {
            realm.add(app)
        }

        XCTAssertEqual(realm.objects(Job.self).count, 5)

        let row = Row(
            filter: Filter.unread,
            title: "",
            icon: "",
            moveable: false,
            showTitleAsPrompt: false,
            accountUUID: nil
        )

        if let sut = Job.byRowFilter(provider: realm, row: row) {
            XCTAssertEqual(sut.count, 3)
            XCTAssertEqual(sut.first, job2)
            XCTAssertEqual(sut.last, job1)
        }
    }

    func testTrashedForSingleAccount() {
        let app = App()
        let account = Account()

        let job1 = Job(value: ["trash": true, "pubDate": Date(timeIntervalSinceNow: 1000)])
        let job2 = Job(value: ["trash": true, "pubDate": Date(timeIntervalSinceNow: 1)])
        let job3 = Job(value: ["trash": true, "read": true, "pubDate": Date(timeIntervalSinceNow: 10)])
        let job4 = Job(value: ["trash": true, "favourite": true, "pubDate": Date(timeIntervalSinceNow: 100)])
        let job5 = Job(value: ["trash": false, "read": false])
        job1.account = account
        job2.account = account
        job3.account = account
        job4.account = account
        job5.account = account

        account.jobs.append(job1)
        account.jobs.append(job2)
        account.jobs.append(job3)
        account.jobs.append(job4)
        account.jobs.append(job5)
        app.accounts.append(account)

        XCTAssertEqual(realm.objects(Job.self).count, 0)

        // swiftlint:disable:next force_try
        try! realm.write {
            realm.add(app)
        }

        XCTAssertEqual(realm.objects(Job.self).count, 5)

        let row = Row(
            filter: Filter.trash,
            title: "",
            icon: "",
            moveable: false,
            showTitleAsPrompt: false,
            accountUUID: account.uuid
        )

        if let sut = Job.byRowFilter(provider: realm, row: row) {
            XCTAssertEqual(sut.count, 4)
            XCTAssertEqual(sut.first, job2)
            XCTAssertEqual(sut.last, job1)
        }
    }

    func testTrashedForAllAccount() {
        let app = App()
        let activeAccount = Account(value: ["urlKey": "A", "active": true])
        let inactiveAccount = Account(value: ["urlKey": "B", "active": false])

        let job1 = Job(value: ["trash": true, "pubDate": Date(timeIntervalSinceNow: 1000)])
        let job2 = Job(value: ["trash": true, "pubDate": Date(timeIntervalSinceNow: 1)])
        let job3 = Job(value: ["trash": true, "read": true, "pubDate": Date(timeIntervalSinceNow: 10)])
        let job4 = Job(value: ["trash": true, "favourite": true, "pubDate": Date(timeIntervalSinceNow: 100)])
        let job5 = Job(value: ["trash": false, "read": false])
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
        app.accounts.append(activeAccount)
        app.accounts.append(inactiveAccount)

        XCTAssertEqual(realm.objects(Job.self).count, 0)

        // swiftlint:disable:next force_try
        try! realm.write {
            realm.add(app)
        }

        XCTAssertEqual(realm.objects(Job.self).count, 5)

        let row = Row(
            filter: Filter.trash,
            title: "",
            icon: "",
            moveable: false,
            showTitleAsPrompt: false,
            accountUUID: nil
        )

        if let sut = Job.byRowFilter(provider: realm, row: row) {
            XCTAssertEqual(sut.count, 3)
            XCTAssertEqual(sut.first, job2)
            XCTAssertEqual(sut.last, job1)
        }
    }
    // swiftlint:disable:next file_length
}
