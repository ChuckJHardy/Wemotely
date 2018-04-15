import XCTest
import SwiftHash

@testable import Wemotely

class JobTests: BaseTestCase {
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testDefaults() {
        let job = Job()

        XCTAssertEqual(job.guid, "")
        XCTAssertEqual(job.title, "Null Title")
        XCTAssertEqual(job.company, "Null Company")
        XCTAssertEqual(job.body, "<h1>Null Body</h1>")
        XCTAssertEqual(job.link, nil)
        XCTAssertEqual(job.read, false)
        XCTAssertEqual(job.trash, false)
        XCTAssertEqual(job.favourite, false)
        XCTAssertEqual(job.pubDate.timeIntervalSince1970, Date().timeIntervalSince1970, accuracy: 100)
    }

    func testUUID() {
        let job1 = Job()
        let job2 = Job()

        XCTAssertEqual(job1.uuid.count, NSUUID().uuidString.count)
        XCTAssertNotEqual(job1.uuid, job2.uuid)
    }

    func testGUID() {
        let url = "https://example.com"
        let job1 = Job(["guid": url])

        XCTAssertEqual(job1.guid, MD5(url))
    }

    func testPrimaryKey() {
        XCTAssertEqual(Job.primaryKey(), "uuid")
    }

    func testIndexedProperties() {
        XCTAssertEqual(Job.indexedProperties(), ["guid"])
    }

    func testCreatingJob() {
        let testDate = Date(timeInterval: 1000, since: Date())
        let job = Job([
            "guid": "https://example.com/guid",
            "title": "Test Title",
            "company": "Test Company",
            "body": "Test Body",
            "link": "https://example.com/link",
            "read": true,
            "trash": true,
            "favourite": true,
            "pubDate": testDate
        ])

        XCTAssertEqual(realm.objects(Job.self).count, 0)

        // swiftlint:disable:next force_try
        try! realm.write {
            realm.add(job, update: true)
        }

        XCTAssertEqual(realm.objects(Job.self).count, 1)

        let findJob = realm.objects(Job.self).first

        XCTAssertEqual(findJob?.guid, MD5("https://example.com/guid"))
        XCTAssertEqual(findJob?.title, "Test Title")
        XCTAssertEqual(findJob?.company, "Test Company")
        XCTAssertEqual(findJob?.body, "Test Body")
        XCTAssertEqual(findJob?.link, "https://example.com/link")
        XCTAssertEqual(findJob?.read, true)
        XCTAssertEqual(findJob?.trash, true)
        XCTAssertEqual(findJob?.favourite, true)
        XCTAssertEqual(findJob?.pubDate, testDate)
    }

    func testMarkAsRead() {
        let job = Job()

        XCTAssertFalse(job.read)
        Job.markAsRead(provider: realm, job: job)
        XCTAssertTrue(job.read)
    }
}
