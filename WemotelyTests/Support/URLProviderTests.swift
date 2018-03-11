import XCTest

@testable import Wemotely

class URLProviderTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testURLWhenTesting() {
        let provider = URLProvider(key: "remote-copywriting-jobs")
        XCTAssertTrue(provider.url().absoluteString.contains("jobs.xml"))
    }

    func testURLWhenNotTesting() {
        let key = "remote-copywriting-jobs"
        let sut = URLProvider(key: key).url(isTesting: false)
        let expectedURL = URL(string: "https://weworkremotely.com/categories/\(key).rss")

        XCTAssertEqual(sut, expectedURL)
    }
}
