import UIKit
import RealmSwift
import FeedKit

extension JobsTableViewController {
    func setupRefreshControl() {
        if let row = row, row.refreshable {
            tableView.refreshControl = refresher

            let accounts = Account.refreshable(provider: realm, uuid: row.accountUUID)
            setRefreshMessage(account: accounts?.first)

            refresher.addTarget(self, action: #selector(refreshJobs(_:)), for: .valueChanged)
        }
    }

    @objc private func refreshJobs(_ sender: Any) {
        let accounts = Account.refreshable(provider: realm, uuid: row?.accountUUID)

        GetJobsService(accounts: accounts).call(completion: { (uuids) in
            let accounts = Account.byUUID(provider: self.realm, uuids: uuids)

            self.setRefreshMessage(account: accounts?.first)
            self.tableView.reloadData()
            self.refresher.endRefreshing()
        })
    }

    private func setRefreshMessage(account: Account?) {
        var message = "Pull to refresh"

        if let date = account?.lastUpdated {
            message = "Last updated \(formatDate(date: date))"
        }

        refresher.attributedTitle = NSAttributedString(string: message)
    }

    private func formatDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        dateFormatter.locale = Locale(identifier: "en_US")
        return dateFormatter.string(from: date)
    }
}
