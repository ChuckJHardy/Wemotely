import XCTest
import RealmSwift

@testable import Wemotely

class GetJobsServiceTests: BaseTestCase {
    var updatedAt: Date!

    func testE2E() {
        let account1 = Account(value: ["urlKey": "A"])
        let account2 = Account(value: ["urlKey": "B"])

        saveApp { (app) in
            app.accounts.append(account1)
            app.accounts.append(account2)
        }

        let account1PreviousCount = account1.jobs.count
        let account2PreviousCount = account2.jobs.count

        let accounts = realmProvider.objects(Account.self)
        let service = GetJobsService(accounts: accounts)

        let exp = expectation(description: "Completion")

        service.call { (updatedAt) in
            self.updatedAt = updatedAt
            exp.fulfill()
        }

        waitForExpectations(timeout: 10)

        XCTAssertNotNil(updatedAt)
        XCTAssertEqual(account1.lastUpdated, updatedAt)
        XCTAssertEqual(account2.lastUpdated, updatedAt)
        XCTAssertLessThan(account1PreviousCount, account1.jobs.count)
        XCTAssertLessThan(account2PreviousCount, account2.jobs.count)
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
