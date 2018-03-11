import XCTest

@testable import Wemotely

class BaseTestCase: XCTestCase {
    let realm = RealmProvider.realm()

    override func setUp() {
        super.setUp()

        try! realm.write { () -> Void in
            realm.deleteAll()
        }
    }
}
