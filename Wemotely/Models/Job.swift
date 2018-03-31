import Foundation
import RealmSwift
import SwiftHash

class Job: Object {
    static let defaultSortKey = "pubDate"

    @objc dynamic var uuid = NSUUID().uuidString
    @objc dynamic var guid: String = ""

    @objc dynamic var title = "Null Title"
    @objc dynamic var company = "Null Company"
    @objc dynamic var body = "<h1>Null Body</h1>"
    @objc dynamic var link: String?
    @objc dynamic var read = false
    @objc dynamic var trash = false
    @objc dynamic var favourite = false
    @objc dynamic var pubDate = Date()
    @objc dynamic var account: Account?

    required convenience init(_ map: [String: Any]) {
        self.init(value: map)

        if let key = map["guid"] as? String {
            self.guid = MD5(key)
        }
    }

    override static func primaryKey() -> String? {
        return "uuid"
    }

    override static func indexedProperties() -> [String] {
        return ["guid"]
    }
}
