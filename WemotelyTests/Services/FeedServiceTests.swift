import XCTest
import SwiftHash

@testable import Wemotely

class FeedServiceTests: BaseTestCase {
    func testE2E() {
        let account = Account()
        let url = URLProviderFactory().build(key: "remote-programming-jobs").rss()
        let testDate = Date(timeInterval: 1000, since: Date())
        let feedService = FeedService(
            provider: realm,
            account: account,
            updatedAt: testDate
        )

        XCTAssertNil(account.lastUpdated)

        if let result = feedService.parser(url: url)?.parse() {
            feedService.save(feed: result.rssFeed!)

            XCTAssertEqual(account.jobs.count, 2)

            let firstJob = account.jobs.first
            XCTAssertEqual(firstJob?.account?.uuid, account.uuid)
            XCTAssertEqual(firstJob?.title, "Awesome Job Titles")
            XCTAssertEqual(firstJob?.company, "A Company")
            XCTAssertEqual(firstJob?.body.count, 11)
            XCTAssertEqual(
                firstJob?.guid,
                MD5("https://weworkremotely.com/remote-jobs/nurelm-inc-full-stack-dev-with-rails-focus-other")
            )
            XCTAssertEqual(
                firstJob?.link,
                "https://weworkremotely.com/remote-jobs/nurelm-inc-full-stack-dev-with-rails-focus"
            )

            XCTAssertEqual(account.lastUpdated, testDate)
        }
    }
}
