import Foundation
import RealmSwift
import FeedKit

struct GetJobsService {
    var privider: Realm!
    var accounts: Results<Account>?

    func call(block: @escaping () -> Void) {
        for account in accounts! {
            var feed: RSSFeed!
            let feedService = FeedService(account: account)

            let feedURL = URLProvider(key: account.urlKey!).url()

            feedService.parser(url: feedURL)?.parseAsync(queue: DispatchQueue.global(qos: .userInitiated)) { (result) in
                feed = result.rssFeed!

                DispatchQueue.main.async {
                    feedService.save(realm: self.privider, feed: feed)

                    logger.info("-> Refreshed Job Data: \(String(describing: feed.items?.count))")

                    block()
                }
            }
        }
    }
}
