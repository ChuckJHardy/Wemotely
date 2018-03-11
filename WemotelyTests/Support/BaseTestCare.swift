import XCTest

@testable import Wemotely

class BaseTestCase: XCTestCase {
    override func setUp() {
        super.setUp()

        let realm = RealmProvider.realm()

        try! realm.write { () -> Void in
            realm.deleteAll()
        }
    }
}
