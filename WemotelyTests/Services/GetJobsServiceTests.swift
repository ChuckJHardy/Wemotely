import XCTest
import RealmSwift

@testable import Wemotely

class GetJobsServiceTests: BaseTestCase {
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    // MARK: - generateThreadSafeAccounts

    func testGenerateThreadSafeAccounts() {
        let app = App()
        let account1 = Account(value: ["urlKey": "A"])
        let account2 = Account(value: ["urlKey": "B"])

        app.accounts.append(account1)
        app.accounts.append(account2)

        // swiftlint:disable:next force_try
        try! realmProvider.write {
            realmProvider.add(app, update: true)
        }

        let accounts = realmProvider.objects(Account.self)
        let service = GetJobsService(accounts: accounts)
        let sut = service.generateThreadSafeAccounts()

        XCTAssertEqual(sut, [account1.uuid, account2.uuid])
    }
}
