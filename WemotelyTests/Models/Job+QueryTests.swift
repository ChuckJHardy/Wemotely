import XCTest

@testable import Wemotely

class JobQueryTests: BaseTestCase {
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testUnorganisedForSingleAccount() {
        let realm = RealmProvider.realm()
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

        let sut = Job.unorganised(provider: realm, accountUUID: account.uuid)

        XCTAssertEqual(sut.count, 2)
        XCTAssertEqual(sut.first, job2)
        XCTAssertEqual(sut.last, job1)
    }

    func testUnorganisedForAllAccounts() {
        let realm = RealmProvider.realm()
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

        let sut = Job.unorganised(provider: realm)

        XCTAssertEqual(sut.count, 2)
        XCTAssertEqual(sut.first, job2)
        XCTAssertEqual(sut.last, job1)
    }
}
