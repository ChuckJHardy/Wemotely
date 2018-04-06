import XCTest

@testable import Wemotely

class BaseTestCase: XCTestCase {
    let realm = realmProvider

    // List of locales https://gist.github.com/jacobbubu/1836273
    let locale = Locale(identifier: "en_US")

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
