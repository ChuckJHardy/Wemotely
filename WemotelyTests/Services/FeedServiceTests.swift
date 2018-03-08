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
    
    func fileURL(_ name: String, type: String) -> URL {
        let bundle = Bundle(for: Swift.type(of: self))
        let filePath = bundle.path(forResource: name, ofType: type)!
        return URL(fileURLWithPath: filePath)
    }
    
    func testE2E() {
        let url = fileURL("remote-programming-jobs", type: "xml")
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
