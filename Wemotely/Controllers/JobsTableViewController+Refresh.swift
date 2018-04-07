import UIKit
import RealmSwift
import FeedKit

extension JobsTableViewController {
    func setupRefreshControl() {
        if let row = row, row.refreshable {
            refresher.addTarget(self, action: #selector(refreshJobs(_:)), for: .valueChanged)
            refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
            tableView.refreshControl = refresher
        }
    }

    @objc private func refreshJobs(_ sender: Any) {
        let accounts = Account.refreshable(provider: realmProvider, uuid: row?.accountUUID)

        GetJobsService(accounts: accounts).call(completion: { _ in
            self.didEdit = true
            self.tableView.reloadData()
            self.refresher.endRefreshing()
        })
    }
}
