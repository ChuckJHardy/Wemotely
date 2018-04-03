import XCTest

@testable import Wemotely

struct TestFixtures {
    struct Rows {
        static let standardRow = Row(
            filter: Filter.inbox,
            title: Filter.inbox.rawValue,
            icon: "",
            moveable: false,
            refreshable: false,
            showTitleAsPrompt: true,
            accountUUID: nil
        )

        static let refreshableRow = Row(
            filter: Filter.inbox,
            title: Filter.inbox.rawValue,
            icon: "",
            moveable: false,
            refreshable: true,
            showTitleAsPrompt: true,
            accountUUID: nil
        )
    }
}
