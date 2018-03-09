import Foundation
import RealmSwift

class App: Object {
    @objc dynamic var uuid = NSUUID().uuidString
    
    @objc dynamic var seeded: Bool = false
    
    let accounts = List<Account>()
    
    override static func primaryKey() -> String? {
        return "uuid"
    }
}
