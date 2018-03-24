import Foundation
import RealmSwift

class Job: Object {
    static let defaultSortKey = "pubDate"

    @objc dynamic var uuid = NSUUID().uuidString

    @objc dynamic var title = "Null Title"
    @objc dynamic var company = "Null Company"
    @objc dynamic var body = "<h1>Null Body</h1>"
    @objc dynamic var read = false
    @objc dynamic var trash = false
    @objc dynamic var favourite = false
    @objc dynamic var pubDate = Date()

    override static func primaryKey() -> String? {
        return "uuid"
    }
}
