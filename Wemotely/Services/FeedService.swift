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
        print("Feed: \(String(describing: feed.items?.count))")
        
        for item in feed.items! {
            let job = Job()
            
            let titleCaptures = item.title?.split(separator: ":")
            let company = titleCaptures?.first?.trimmingCharacters(in: .whitespacesAndNewlines)
            let jobTitle = titleCaptures?.last?.trimmingCharacters(in: .whitespacesAndNewlines)
            
            job.title = jobTitle!
            job.company = company!
            job.body = item.description!
            job.pubDate = item.pubDate!
            
            account.jobs.append(job)
        }
        
        return account
    }
}

