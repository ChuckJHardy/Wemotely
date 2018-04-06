import Foundation
import RealmSwift

extension Account {
    static func byUUID(provider: Realm, uuid: String) -> Account? {
        return byUUID(provider: provider, uuids: [uuid])?.last
    }

    static func byUUID(provider: Realm, uuids: [String]) -> Results<Account>? {
        return provider
            .objects(Account.self)
            .filter("uuid IN %@", uuids)
    }

    static func refreshable(provider: Realm, uuid: String? = nil) -> Results<Account>? {
        if let uuid = uuid {
            return byUUID(provider: provider, uuids: [uuid])
        } else {
            return activeSorted(provider: provider)
        }
    }

    static func allSorted(provider: Realm) -> Results<Account> {
        return provider
            .objects(Account.self)
            .sorted(byKeyPath: "order")
    }

    static func activeSorted(provider: Realm) -> Results<Account> {
        return provider
            .objects(Account.self)
            .filter("active = %@", true)
            .sorted(byKeyPath: "order")
    }
}
