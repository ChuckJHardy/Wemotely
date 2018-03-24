import XCTest

@testable import Wemotely

class FeedServiceTests: BaseTestCase {
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testE2E() {
        let account = Account()
        let url = URLProvider(key: "remote-programming-jobs").url()
        let feedService = FeedService(account: account)

        if let result = feedService.parser(url: url)?.parse() {
            feedService.save(realm: realm, feed: result.rssFeed!)

            XCTAssertEqual(account.jobs.count, 2)

            let firstJob = account.jobs.first
            XCTAssertEqual(firstJob?.title, "Full Stack Dev with Rails Focus")
            XCTAssertEqual(firstJob?.company, "NuRelm, Inc.")
            XCTAssertEqual(firstJob?.body.count, 4826)
            XCTAssertEqual(firstJob?.account?.uuid, account.uuid)
        }
    }
}
