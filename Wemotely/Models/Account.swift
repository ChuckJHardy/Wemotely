import Foundation
import RealmSwift

class Account: Object {
    @objc dynamic var uuid = NSUUID().uuidString

    @objc dynamic var title: String = "Null Title"
    @objc dynamic var icon: String = "null_icon"
    @objc dynamic var unreadCount: Int = 0
    @objc dynamic var active: Bool = true
    @objc dynamic var urlKey: String?
    @objc dynamic var order: Int = 0

    let jobs = List<Job>()

    override static func primaryKey() -> String? {
        return "urlKey"
    }
}
