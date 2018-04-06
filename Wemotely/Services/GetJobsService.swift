import Foundation
import RealmSwift
import FeedKit

struct GetJobsService {
    var accounts: Results<Account>!

    func call(completion: @escaping (_ uuids: [String]) -> Void) {
        let uuids = generateThreadSafeAccounts()

        DispatchQueue.global(qos: .background).async {
            let threadProvider = RealmProvider.realm()
            let threadSafeAccounts = Account.byUUID(provider: threadProvider, uuids: uuids)

            for account in threadSafeAccounts! {
                let feedService = FeedService(account: account)
                let feedURL = URLProvider(key: account.urlKey!).url()
                if let result = feedService.parser(url: feedURL)?.parse() {
                    feedService.save(realm: threadProvider, feed: result.rssFeed!)
                }
            }

            Platform.delayBackgroundProcessBy()

            DispatchQueue.main.async {
                completion(uuids)
            }
        }
    }

    private func generateThreadSafeAccounts() -> [String] {
        return accounts.map { $0.uuid }
    }
}
