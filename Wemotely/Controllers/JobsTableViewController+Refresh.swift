import UIKit

extension JobsTableViewController {
    func setupRefreshControl() {
        if let row = row, row.refreshable {
            findAccountsToRefresh(row: row)

            tableView.refreshControl = refresher
            setRefreshTitle(accountUUID: row.accountUUID)
            refresher.addTarget(self, action: #selector(refreshJobs(_:)), for: .valueChanged)
        }
    }

    @objc private func refreshJobs(_ sender: Any) {
        GetJobsService(privider: realm, accounts: accounts).call { (account) in
            do {
                try self.realm.write {
                    account.lastUpdated = Date()
                }
            } catch let err {
                logger.error("Failed to update account lastUpdated", err)
            }

            self.setRefreshTitle(accountUUID: account.uuid)

            self.tableView.reloadData()
            self.refresher.endRefreshing()
        }
    }

    private func setRefreshTitle(accountUUID: String?) {
        let account = Account.byUUID(provider: realm, uuid: accountUUID!)
        refresher.attributedTitle = NSAttributedString(string: refreshMessage(account: account))
    }

    private func refreshMessage(account: Account?) -> String {
        if let account = account, let date = account.lastUpdated {
            return "Last updated \(formatDate(date: date))"
        } else {
            return "Pull to refresh"
        }
    }

    private func formatDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        dateFormatter.locale = Locale(identifier: "en_US")
        return dateFormatter.string(from: date)
    }

    private func findAccountsToRefresh(row: Row) {
        if let accountUUID = row.accountUUID {
            accounts = Account.allByUUID(provider: realm, uuid: accountUUID)
        } else {
            accounts = Account.activeSorted(provider: realm)
        }
    }
}
