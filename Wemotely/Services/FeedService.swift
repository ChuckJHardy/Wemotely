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
                BuildJob(record: item).build()
            )
        }
    }

    struct BuildJob {
        let titleSeperator = Character(":")
        let job = Job()

        var record: RSSFeedItem

        func build() -> Job {
            let captures = titleCaptures()

            job.title = trim(str: captures?.last)!
            job.company = trim(str: captures?.first)!
            job.body = record.description!
            job.pubDate = record.pubDate!

            return job
        }

        private func titleCaptures() -> [String.SubSequence]? {
            return record.title?.split(separator: titleSeperator)
        }

        private func trim(str: String.SubSequence?) -> String? {
            return str?.trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }
}
