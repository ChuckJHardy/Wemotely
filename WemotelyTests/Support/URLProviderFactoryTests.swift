import XCTest

@testable import Wemotely

class URLProviderFactoryTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testURLWhenTesting() {
        let key = "remote-copywriting-jobs"
        XCTAssertTrue(URLProviderFactory().build(key: key).url().absoluteString.contains("jobs.xml"))
        XCTAssertTrue(URLProviderFactory().build(key: key).url().absoluteString.contains("jobs-other.xml"))
    }

    func testURLWhenNotTestingURL() {
        let key = "remote-copywriting-jobs"
        let sut = URLProviderFactory(isTesting: false).build(key: key).url()
        let expectedURL = URL(string: "https://weworkremotely.com/categories/\(key)")

        XCTAssertEqual(sut, expectedURL)
    }

    func testURLWhenNotTestingRSS() {
        let key = "remote-copywriting-jobs"
        let sut = URLProviderFactory(isTesting: false).build(key: key).rss()
        let expectedURL = URL(string: "https://weworkremotely.com/categories/\(key).rss")

        XCTAssertEqual(sut, expectedURL)
    }
}
