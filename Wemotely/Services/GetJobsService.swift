import Foundation
import RealmSwift
import FeedKit

struct GetJobsService {
    var accounts: Results<Account>!

    func call(completion: @escaping () -> Void) {
        let uuids = generateThreadSafeAccounts()

        DispatchQueue.global(qos: .background).async {
            logger.info(uuids)

            let threadProvider = RealmProvider.realm()
            let threadSafeAccounts = Account.byUUID(provider: threadProvider, uuids: uuids)

            for account in threadSafeAccounts! {
                let feedService = FeedService(account: account)
                let feedURL = URLProvider(key: account.urlKey!).url()
                if let result = feedService.parser(url: feedURL)?.parse() {
                    feedService.save(realm: threadProvider, feed: result.rssFeed!)
                }
            }

            DispatchQueue.main.async {
                completion()
            }
        }
    }

    func generateThreadSafeAccounts() -> [String] {
        var uuids: [String] = []
        for account in accounts { uuids.append(account.uuid) }
        return uuids
    }
}
