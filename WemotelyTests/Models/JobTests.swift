import XCTest

@testable import Wemotely

class JobTests: XCTestCase {
    override func setUp() {
        super.setUp()

        let realm = RealmProvider.realm()

        try! realm.write { () -> Void in
            realm.deleteAll()
        }
    }

    override func tearDown() {
        super.tearDown()
    }

    func testDefaults() {
        let job = Job()

        XCTAssertEqual(job.title, "Null Title")
        XCTAssertEqual(job.company, "Null Company")
        XCTAssertEqual(job.body, "<h1>Null Body</h1>")
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

    func testPrimaryKey() {
        XCTAssertEqual(Job.primaryKey(), "uuid")
    }

    func testCreatingJob() {
        let realm = RealmProvider.realm()

        let job = Job()
        let testDate = Date(timeInterval: 1000, since: Date())

        job.title = "Test Title"
        job.company = "Test Company"
        job.body = "Test Body"
        job.read = true
        job.trash = true
        job.favourite = true
        job.pubDate = testDate

        XCTAssertEqual(realm.objects(Job.self).count, 0)

        try! realm.write {
            realm.add(job, update: true)
        }

        XCTAssertEqual(realm.objects(Job.self).count, 1)

        let findJob = realm.objects(Job.self).first

        XCTAssertEqual(findJob?.title, "Test Title")
        XCTAssertEqual(findJob?.company, "Test Company")
        XCTAssertEqual(findJob?.body, "Test Body")
        XCTAssertEqual(findJob?.read, true)
        XCTAssertEqual(findJob?.trash, true)
        XCTAssertEqual(findJob?.favourite, true)
        XCTAssertEqual(findJob?.pubDate, testDate)
    }
}
