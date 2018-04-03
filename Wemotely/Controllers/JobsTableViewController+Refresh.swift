import UIKit
import RealmSwift
import FeedKit

extension JobsTableViewController {
    func setupRefreshControl() {
        if let row = row, row.refreshable {
            tableView.refreshControl = refresher
            self.setRefreshMessage(accountUUID: row.accountUUID)
            refresher.addTarget(self, action: #selector(refreshJobs(_:)), for: .valueChanged)
        }
    }

    @objc private func refreshJobs(_ sender: Any) {
        let accounts = Account.refreshable(provider: realm, uuid: row?.accountUUID)

        GetJobsService(accounts: accounts).call(completion: {
            self.tableView.reloadData()
            self.refresher.endRefreshing()
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
}
