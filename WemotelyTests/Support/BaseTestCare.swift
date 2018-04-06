import XCTest

@testable import Wemotely

class BaseTestCase: XCTestCase {
    // let realm = RealmProvider.realm()
    let realm = realmProvider

    override func setUp() {
        super.setUp()

        RealmProvider.deleteAll(realm: realm)
    }
}
