import UIKit
import FeedKit

extension JobsTableViewController {
    func setupRefreshControl() {
        if let row = row, row.refreshable {
            findAccountsToRefresh(row: row)

            tableView.refreshControl = refresher
            // Add Last Updated
            refresher.attributedTitle = NSAttributedString(string: "Pull to refresh jobs")
            refresher.addTarget(self, action: #selector(refreshJobs(_:)), for: .valueChanged)
        }
    }

    @objc private func refreshJobs(_ sender: Any) {
        logger.info("-> Refreshing Job Data")

        GetJobsService(privider: realm, accounts: accounts).call {
            self.refresher.endRefreshing()
            self.tableView.reloadData()
        }
    }

    private func findAccountsToRefresh(row: Row) {
        if let accountUUID = row.accountUUID {
            accounts = Account.allByUUID(provider: realm, uuid: accountUUID)
        } else {
            accounts = Account.activeSorted(provider: realm)
        }
    }
}
