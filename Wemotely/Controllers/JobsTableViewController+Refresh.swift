import UIKit
import RealmSwift
import FeedKit

extension JobsTableViewController {
    func setupRefreshControl() {
        runWhenRefreshable { _ in
            self.refresher.addTarget(self, action: #selector(self.refreshJobs(_:)), for: .valueChanged)
            self.refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
            self.tableView.refreshControl = self.refresher
        }
    }

    @objc private func refreshJobs(_ sender: Any) {
        GetJobsService(accounts: accounts).call(completion: { (updatedAt) in
            self.didEdit = true
            self.navigationItem.prompt = JobsPresenter().navigationPrompt(date: updatedAt)
            self.tableView.reloadData()
            self.refresher.endRefreshing()
        })
    }

    internal func updateNavigationPromptFromAccounts(other: ((_ row: Row) -> Void)? = nil) {
        runWhenRefreshable { (row) in
            if let block = other { block(row) }

            let oldestAccount = Account.oldest(provider: realmProvider, accounts: accounts)
            if let account = oldestAccount, let lastUpdated = account.lastUpdated {
                navigationItem.prompt = JobsPresenter().navigationPrompt(date: lastUpdated)
            }
        }
    }
}
