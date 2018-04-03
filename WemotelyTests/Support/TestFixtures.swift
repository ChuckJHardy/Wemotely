import XCTest

@testable import Wemotely

struct TestFixtures {
    struct Rows {
        static let standardRow = Row(
            filter: Filter.favourites,
            title: Filter.favourites.rawValue,
            icon: "heart",
            moveable: true,
            refreshable: false,
            showTitleAsPrompt: true,
            accountUUID: nil
        )
    }
}
