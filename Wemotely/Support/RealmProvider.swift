import Foundation
import RealmSwift

class RealmProvider {
    class func realm() -> Realm {
        if let _ = NSClassFromString("XCTest") {
            return try! Realm(
                configuration: Realm.Configuration(
                    fileURL: nil,
                    inMemoryIdentifier: "test",
                    encryptionKey: nil,
                    readOnly: false,
                    schemaVersion: 0,
                    migrationBlock: nil,
                    objectTypes: nil
                )
            )
        } else {
            return try! Realm();
        }
    }
}
