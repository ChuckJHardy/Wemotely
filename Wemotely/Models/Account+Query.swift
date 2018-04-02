import Foundation
import RealmSwift

extension Account {
    static func byUUID(provider: Realm, uuid: String) -> Account? {
        return allByUUID(provider: provider, uuid: uuid)?.last
    }

    static func allByUUID(provider: Realm, uuid: String) -> Results<Account>? {
        return provider
            .objects(Account.self)
            .filter("uuid = %@", uuid)
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
