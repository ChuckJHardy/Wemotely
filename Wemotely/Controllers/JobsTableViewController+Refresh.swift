import UIKit
import RealmSwift
import FeedKit

extension JobsTableViewController {
    func setupRefreshControl() {
        if let row = row, row.refreshable {
            tableView.refreshControl = refresher

            let accounts = Account.refreshable(provider: realmProvider, uuid: row.accountUUID)
            setRefreshMessage(account: accounts?.first)

            refresher.addTarget(self, action: #selector(refreshJobs(_:)), for: .valueChanged)
        }
    }

    @objc private func refreshJobs(_ sender: Any) {
        let accounts = Account.refreshable(provider: realmProvider, uuid: row?.accountUUID)

        GetJobsService(accounts: accounts).call(completion: { (uuids) in
            let accounts = Account.byUUID(provider: realmProvider, uuids: uuids)

            self.didEdit = true
            self.setRefreshMessage(account: accounts?.first)
            self.tableView.reloadData()
            self.refresher.endRefreshing()
        })
    }

    private func setRefreshMessage(account: Account?) {
        let message = JobsPresenter().pullToRefreshMessage(date: account?.lastUpdated)
        refresher.attributedTitle = NSAttributedString(string: message)
    }
}
