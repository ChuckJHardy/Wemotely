import XCTest

@testable import Wemotely

class BaseTestCase: XCTestCase {
    // let realm = RealmProvider.realm()
    let realm = realmProvider

    // List of locales https://gist.github.com/jacobbubu/1836273
    let locale = Locale(identifier: "en_US")

    override func setUp() {
        super.setUp()

        RealmProvider.deleteAll(realm: realm)
    }
}
