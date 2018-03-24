import Foundation
import RealmSwift

struct Section {
    var heading: String = ""
    var showHeader: Bool = true

    var rows: [Row]
}

struct Row {
    var filter: Filter = Filter.unorganised
    var title: String = ""
    var icon: String = ""
    var moveable: Bool = false
    var showTitleAsPrompt: Bool = false
    var accountUUID: String?
}

class DashboardPresenter: NSObject {
    var accounts: Results<Account>

    init(accounts: Results<Account>) {
        self.accounts = accounts
    }

    func present() -> [Section] {
        return [
            mainSection()
        ] + accountSections()
    }

    private func mainSection() -> Section {
        return Section(
            heading: "",
            showHeader: false,
            rows: mainSectionRows()
        )
    }

    private func mainSectionRows() -> [Row] {
        return [
            Row(
                filter: Filter.unorganised,
                title: Filter.unorganised.rawValue,
                icon: "inboxes",
                moveable: true,
                showTitleAsPrompt: true,
                accountUUID: nil
            ),
            Row(
                filter: Filter.favourites,
                title: Filter.favourites.rawValue,
                icon: "heart",
                moveable: true,
                showTitleAsPrompt: true,
                accountUUID: nil
            ),
            Row(
                filter: Filter.unread,
                title: Filter.unread.rawValue,
                icon: "unread",
                moveable: true,
                showTitleAsPrompt: true,
                accountUUID: nil
            ),
            Row(
                filter: Filter.trash,
                title: Filter.trash.rawValue,
                icon: "trash",
                moveable: true,
                showTitleAsPrompt: true,
                accountUUID: nil
            )
        ] + rowsFromAccounts()
    }

    private func rowsFromAccounts() -> [Row] {
        var list: [Row] = []

        for account in accounts {
            let row = Row(
                filter: Filter.inbox,
                title: account.title,
                icon: "inbox",
                moveable: true,
                showTitleAsPrompt: false,
                accountUUID: account.uuid
            )

            list.append(row)
        }

        return list
    }

    private func accountSections() -> [Section] {
        var list: [Section] = []

        for account in accounts {
            let section = Section(
                heading: account.title,
                showHeader: true,
                rows: [
                    Row(
                        filter: Filter.inbox,
                        title: Filter.inbox.rawValue,
                        icon: "inbox",
                        moveable: false,
                        showTitleAsPrompt: true,
                        accountUUID: account.uuid
                    ),
                    Row(
                        filter: Filter.favourites,
                        title: Filter.favourites.rawValue,
                        icon: "heart",
                        moveable: false,
                        showTitleAsPrompt: true,
                        accountUUID: account.uuid
                    ),
                    Row(
                        filter: Filter.unread,
                        title: Filter.unread.rawValue,
                        icon: "unread",
                        moveable: false,
                        showTitleAsPrompt: true,
                        accountUUID: account.uuid
                    ),
                    Row(
                        filter: Filter.trash,
                        title: Filter.trash.rawValue,
                        icon: "trash",
                        moveable: false,
                        showTitleAsPrompt: true,
                        accountUUID: account.uuid
                    )
                ]
            )

            list.append(section)
        }

        return list
    }
}
