import Foundation
import RealmSwift
import FeedKit

struct FeedService {
    var account: Account

    func parser(url: URL) -> FeedParser? {
        return FeedParser(URL: url)
    }

    func save(realm: Realm, feed: RSSFeed) {
        do {
            try realm.write {
                updateWith(feed: feed)
            }
        } catch let err {
            logger.error("FeedService failed to update", err)
        }

    }

    private func updateWith(feed: RSSFeed) {
        for item in feed.items! {
            account.jobs.append(
                BuildJob(record: item).build(linkedAccount: account)
            )
        }
    }

    struct BuildJob {
        let titleSeperator = Character(":")
        let job = Job()

        var record: RSSFeedItem

        func build(linkedAccount: Account) -> Job {
            let captures = titleCaptures()

            return Job([
                "guid": record.guid?.value! as Any,
                "title": trim(str: captures?.last)!,
                "company": trim(str: captures?.first)!,
                "body": record.description!,
                "link": record.link!,
                "pubDate": record.pubDate!,
                "account": linkedAccount
            ])
        }

        private func titleCaptures() -> [String.SubSequence]? {
            return record.title?.split(separator: titleSeperator)
        }

        private func trim(str: String.SubSequence?) -> String? {
            return str?.trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }
}
