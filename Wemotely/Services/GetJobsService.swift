import Foundation
import RealmSwift
import FeedKit

struct GetJobsService {
    var accounts: Results<Account>!

    func call(completion: @escaping (_ updatedAt: Date) -> Void) {
        let uuids = generateThreadSafeAccounts()

        DispatchQueue.global(qos: .background).async {
            let updatedAt = Date()
            let threadProvider = RealmProvider.realm()
            let threadSafeAccounts = Account.byUUID(provider: threadProvider, uuids: uuids)

            for account in threadSafeAccounts! {
                guard !account.isInvalidated else {
                    logger.error("-> Account Invalidated")
                    continue
                }

                let feedService = FeedService(account: account, updatedAt: updatedAt)
                let feedURL = URLProvider(key: account.urlKey!).url()
                if let result = feedService.parser(url: feedURL)?.parse() {
                    feedService.save(realm: threadProvider, feed: result.rssFeed!)
                }
            }

            Platform.delayBackgroundProcessBy()

            DispatchQueue.main.async {
                completion(updatedAt)
            }
        }
    }

    private func generateThreadSafeAccounts() -> [String] {
        return accounts.map { $0.uuid }
    }
}
