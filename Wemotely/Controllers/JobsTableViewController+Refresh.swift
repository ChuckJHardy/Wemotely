import UIKit

extension JobsTableViewController {
    func setupRefreshControl() {
        if let row = row, row.refreshable {
            findAccountsToRefresh(row: row)

            tableView.refreshControl = refresher
            self.setRefreshMessage(accountUUID: row.accountUUID)
            refresher.addTarget(self, action: #selector(refreshJobs(_:)), for: .valueChanged)
        }
    }

    @objc private func refreshJobs(_ sender: Any) {
        GetJobsService(privider: realm, accounts: accounts).call(perAccount: { (account) in
            do {
                try self.realm.write {
                    account.lastUpdated = Date()
                }
            } catch let err {
                logger.error("Failed to update account lastUpdated", err)
            }
        }, completion: {
            UIView.animate(withDuration: 0.5, animations: {
                self.refresher.endRefreshing()
            }, completion: { _ in
                self.tableView.reloadData()
                self.setRefreshMessage()
            })
        })
    }

    private func setRefreshMessage(accountUUID: String? = nil) {
        refresher.attributedTitle = NSAttributedString(string: refreshMessage(accountUUID: accountUUID))
    }

    private func refreshMessage(accountUUID: String?) -> String {
        var message = "Pull to refresh"

        if let uuid = accountUUID {
            let account = Account.byUUID(provider: realm, uuid: uuid)

            if let date = account?.lastUpdated {
                message = "Last updated \(formatDate(date: date))"
            }
        }

        return message
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
