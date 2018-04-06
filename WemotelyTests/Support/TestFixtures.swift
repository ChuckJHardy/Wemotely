import XCTest

@testable import Wemotely

struct TestFixtures {
    struct Rows {
        static func standardRow(accountUUID: String? = nil) -> Row {
            return Row(
                filter: Filter.inbox,
                title: Filter.inbox.rawValue,
                icon: "",
                moveable: false,
                refreshable: true,
                showTitleAsPrompt: true,
                accountUUID: accountUUID
            )
        }

        static func unorganisedRow(accountUUID: String? = nil) -> Row {
            return Row(
                filter: Filter.unorganised,
                title: Filter.unorganised.rawValue,
                icon: "",
                moveable: false,
                refreshable: true,
                showTitleAsPrompt: true,
                accountUUID: accountUUID
            )
        }

        static func favouritedRow(accountUUID: String? = nil) -> Row {
            return Row(
                filter: Filter.favourites,
                title: Filter.favourites.rawValue,
                icon: "",
                moveable: false,
                refreshable: false,
                showTitleAsPrompt: true,
                accountUUID: accountUUID
            )
        }

        static func unreadRow(accountUUID: String? = nil) -> Row {
            return Row(
                filter: Filter.unread,
                title: Filter.unread.rawValue,
                icon: "",
                moveable: false,
                refreshable: false,
                showTitleAsPrompt: true,
                accountUUID: accountUUID
            )
        }

        static func trashedRow(accountUUID: String? = nil) -> Row {
            return Row(
                filter: Filter.trash,
                title: Filter.trash.rawValue,
                icon: "",
                moveable: false,
                refreshable: false,
                showTitleAsPrompt: true,
                accountUUID: accountUUID
            )
        }

        static func refreshableRow(accountUUID: String? = nil) -> Row {
            return Row(
                filter: Filter.inbox,
                title: Filter.inbox.rawValue,
                icon: "",
                moveable: false,
                refreshable: true,
                showTitleAsPrompt: true,
                accountUUID: accountUUID
            )
        }
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
