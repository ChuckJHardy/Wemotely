import Foundation
import RealmSwift

extension Job {
    static func byRowFilter(provider: Realm, row: Row?) -> Results<Job>? {
        if let row = row {
            switch row.filter {
            case .unorganised:
                return Job.unorganised(provider: provider)
            case .favourites:
                return Job.favourited(provider: provider, accountUUID: row.accountUUID)
            case .inbox:
                return Job.unorganised(provider: provider, accountUUID: row.accountUUID)
            case .unread:
                return Job.unread(provider: provider, accountUUID: row.accountUUID)
            case .trash:
                return Job.trashed(provider: provider, accountUUID: row.accountUUID)
            }
        }

        return nil
    }

    static func unorganised(provider: Realm, accountUUID: String? = nil) -> Results<Job> {
        return baseQueryObject(provider: provider, accountUUID: accountUUID)
            .filter("trash == %@ AND favourite == %@", false, false)
    }

    static func favourited(provider: Realm, accountUUID: String?) -> Results<Job> {
        return baseQueryObject(provider: provider, accountUUID: accountUUID)
            .filter("trash == %@ AND favourite == %@", false, true)
    }

    static func unread(provider: Realm, accountUUID: String?) -> Results<Job> {
        return baseQueryObject(provider: provider, accountUUID: accountUUID)
            .filter("read == %@", false)
    }

    static func trashed(provider: Realm, accountUUID: String?) -> Results<Job> {
        return baseQueryObject(provider: provider, accountUUID: accountUUID)
            .filter("trash == %@", true)
    }

    private static func baseQueryObject(provider: Realm, accountUUID: String?) -> Results<Job> {
        if let uuid = accountUUID, let account = Account.byUUID(provider: provider, uuid: uuid) {
            return account.jobs.sorted(byKeyPath: Job.defaultSortKey)
        }

        return provider.objects(Job.self)
            .filter("account.active = %@", true)
            .sorted(byKeyPath: Job.defaultSortKey)
    }
}
