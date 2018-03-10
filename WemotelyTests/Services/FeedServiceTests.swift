import XCTest

@testable import Wemotely

class FeedServiceTests: XCTestCase {
    let realm = RealmProvider.realm()

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testE2E() {
        let url = URLProvider(key: "remote-programming-jobs", parentClass: Swift.type(of: self)).url()
        let feedService = FeedService(account: Account())

        if let result = feedService.parser(url: url)?.parse() {
            let account = feedService.updateWith(feed: result.rssFeed!)

            XCTAssertEqual(account.jobs.count, 25)

            let firstJob = account.jobs.first
            XCTAssertEqual(firstJob?.title, "Full Stack Dev with Rails Focus")
            XCTAssertEqual(firstJob?.company, "NuRelm, Inc.")
            XCTAssertEqual(firstJob?.body.count, 4826)
        }
    }
}
