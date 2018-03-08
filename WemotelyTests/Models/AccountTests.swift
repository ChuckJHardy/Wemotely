import XCTest

@testable import Wemotely

class AccountTests: XCTestCase {
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
        let account = Account()
        
        XCTAssertEqual(account.title, "Null Title")
        XCTAssertEqual(account.icon, "null_icon")
        XCTAssertEqual(account.unreadCount, 0)
        XCTAssertEqual(account.active, true)
        XCTAssertEqual(account.urlKey, nil)
        XCTAssertEqual(account.order, 0)
        XCTAssertEqual(account.jobs.count, 0)
    }
    
    func testUUID() {
        let account1 = Account()
        let account2 = Account()
        
        XCTAssertEqual(account1.uuid.count, NSUUID().uuidString.count)
        XCTAssertNotEqual(account1.uuid, account2.uuid)
    }
    
    func testPrimaryKey() {
        XCTAssertEqual(Account.primaryKey(), "urlKey")
    }
    
    func testCreatingAccount() {
        let realm = RealmProvider.realm()
        
        let account = Account()
        
        account.title = "Test Title"
        account.icon = "Test Icon"
        account.unreadCount = 11
        account.active = false
        account.urlKey = "test_url_key"
        account.order = 22
        
        account.jobs.append(Job())
        account.jobs.append(Job())

        XCTAssertEqual(realm.objects(Account.self).count, 0)
        
        try! realm.write {
            realm.add(account, update: true)
        }
        
        XCTAssertEqual(realm.objects(Account.self).count, 1)
        
        let findAccount = realm.objects(Account.self).first
        
        XCTAssertEqual(findAccount?.title, "Test Title")
        XCTAssertEqual(findAccount?.icon, "Test Icon")
        XCTAssertEqual(findAccount?.unreadCount, 11)
        XCTAssertEqual(findAccount?.active, false)
        XCTAssertEqual(findAccount?.urlKey, "test_url_key")
        XCTAssertEqual(findAccount?.order, 22)
        XCTAssertEqual(findAccount?.jobs.count, 2)
    }
}

