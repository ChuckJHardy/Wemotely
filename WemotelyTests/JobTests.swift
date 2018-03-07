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
    
    func testExample() {
    }
}
