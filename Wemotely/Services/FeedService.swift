import Foundation
import FeedKit

struct FeedService {
    var account: Account
    
    static func urlFrom(key: String) -> URL {
        return URL(string: "https://weworkremotely.com/categories/\(key).rss")!
    }
    
    func parser(url: URL) -> FeedParser? {
        return FeedParser(URL: url)
    }
    
    func updateWith(feed: RSSFeed) -> Account {
        for item in feed.items! {
            account.jobs.append(
                BuildJob(record: item).build()
            )
        }
        
        return account
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

