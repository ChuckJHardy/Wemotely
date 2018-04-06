import XCTest

@testable import Wemotely

struct TestFixtures {
    struct Rows {
        static let standardRow = Row(
            filter: Filter.inbox,
            title: Filter.inbox.rawValue,
            icon: "",
            moveable: false,
            showTitleAsPrompt: true,
            accountUUID: nil
        )

        static let favouritedRow = Row(
            filter: Filter.favourites,
            title: Filter.favourites.rawValue,
            icon: "",
            moveable: false,
            showTitleAsPrompt: true,
            accountUUID: nil
        )

        static let trashedRow = Row(
            filter: Filter.trash,
            title: Filter.trash.rawValue,
            icon: "",
            moveable: false,
            showTitleAsPrompt: true,
            accountUUID: nil
        )

        static let refreshableRow = Row(
            filter: Filter.inbox,
            title: Filter.inbox.rawValue,
            icon: "",
            moveable: false,
            showTitleAsPrompt: true,
            accountUUID: nil
        )
    }

    struct Accounts {
        static func simple(_ key: String = "A", active: Bool = true, order: Int = 0) -> Account {
            return Account(value: [
                "urlKey": key,
                "active": active,
                "order": order
            ])
        }
    }

    struct Jobs {
        static func unorganised(account: Account? = nil) -> Job {
            return Job([
                "guid": "https://example.com",
                "title": "Test Title",
                "company": "Test Company",
                "body": "<h1>Test Body</h1>",
                "link": "https://example.com/test_link",
                "read": false,
                "trash": false,
                "favourite": false,
                "pubDate": Date(),
                "account": account!
            ])
        }

        static func favourited(account: Account? = nil) -> Job {
            return Job([
                "guid": "https://example.com",
                "title": "Test Title",
                "company": "Test Company",
                "body": "<h1>Test Body</h1>",
                "link": "https://example.com/test_link",
                "read": false,
                "trash": false,
                "favourite": true,
                "pubDate": Date(),
                "account": account!
            ])
        }

        static func trashed(account: Account? = nil) -> Job {
            return Job([
                "guid": "https://example.com",
                "title": "Test Title",
                "company": "Test Company",
                "body": "<h1>Test Body</h1>",
                "link": "https://example.com/test_link",
                "read": false,
                "trash": true,
                "favourite": false,
                "pubDate": Date(),
                "account": account!
            ])
        }
    }
}
