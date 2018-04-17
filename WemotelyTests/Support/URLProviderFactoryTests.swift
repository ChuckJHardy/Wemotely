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
        let url = URLProviderFactory().build(key: "remote-copywriting-jobs")
        XCTAssertTrue(url.absoluteString.contains("jobs.xml"))
    }

    func testURLWhenTestingAgain() {
        let key = "remote-copywriting-jobs"
        _ = URLProviderFactory().build(key: key)
        let url = URLProviderFactory().build(key: key)
        XCTAssertTrue(url.absoluteString.contains("jobs-other.xml"))
    }

    func testURLWhenNotTesting() {
        let key = "remote-copywriting-jobs"
        let sut = URLProviderFactory(isTesting: false).build(key: key)
        let expectedURL = URL(string: "https://weworkremotely.com/categories/\(key).rss")

        XCTAssertEqual(sut, expectedURL)
    }
}
