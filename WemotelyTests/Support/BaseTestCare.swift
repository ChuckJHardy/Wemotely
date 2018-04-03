import XCTest

@testable import Wemotely

class BaseTestCase: XCTestCase {
    let realm = RealmProvider.realm()

    override func setUp() {
        super.setUp()
        deleteAll()
    }

    override func tearDown() {
        deleteAll()
        super.tearDown()
    }

    private func deleteAll() {
        RealmProvider.deleteAll(realm: realm)
    }
}
