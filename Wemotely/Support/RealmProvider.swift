import Foundation
import RealmSwift

class RealmProvider {
    class func realm() -> Realm {
        if NSClassFromString("XCTest") != nil {
            // swiftlint:disable:next force_try
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
            // swiftlint:disable:next force_try
            return try! Realm()
        }
    }

    class func deleteAll(realm: Realm) {
        do {
            try realm.write { () -> Void in
                realm.deleteAll()
            }
        } catch let err {
            print("Failed to Delete All Data: \(err)")
        }
    }
}
