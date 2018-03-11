import Foundation
import RealmSwift

struct Section {
    var heading: String = ""
    var showHeader: Bool = true

    var rows: [Row]
}

struct Row {
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
            Row(title: "All Inboxes", icon: "inboxes", moveable: true, showTitleAsPrompt: true, accountUUID: nil),
            Row(title: "Favourites", icon: "heart", moveable: true, showTitleAsPrompt: true, accountUUID: nil),
            Row(title: "Unread", icon: "unread", moveable: true, showTitleAsPrompt: true, accountUUID: nil),
            Row(title: "Trash", icon: "trash", moveable: true, showTitleAsPrompt: true, accountUUID: nil)
        ] + rowsFromAccounts()
    }

    private func rowsFromAccounts() -> [Row] {
        var list: [Row] = []

        for account in accounts {
            let row = Row(
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
                        title: "Inbox",
                        icon: "inbox",
                        moveable: false,
                        showTitleAsPrompt: true,
                        accountUUID: account.uuid
                    ),
                    Row(
                        title: "Favourites",
                        icon: "heart",
                        moveable: false,
                        showTitleAsPrompt: true,
                        accountUUID: account.uuid
                    ),
                    Row(
                        title: "Unread",
                        icon: "unread",
                        moveable: false,
                        showTitleAsPrompt: true,
                        accountUUID: account.uuid
                    ),
                    Row(
                        title: "Trash",
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
