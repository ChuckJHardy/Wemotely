import Foundation
import RealmSwift

extension Account {
    static func byUUID(provider: Realm, uuid: String) -> Account? {
        return provider
            .objects(Account.self)
            .filter("uuid = %@", uuid)
            .last
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
