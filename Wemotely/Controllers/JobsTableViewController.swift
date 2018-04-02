import UIKit
import FeedKit
import RealmSwift

protocol JobsTableViewControllerDelegate: class {
    func didEdit()
}

class JobsTableViewController: UITableViewController {
    let realm = RealmProvider.realm()

    internal let refresher = UIRefreshControl()

    weak var delegate: DashboardTableViewController?
    var row: Row?
    var didEdit: Bool = false

    var jobs: Results<Job>? {
        return Job.byRowFilter(provider: realm, row: row)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.accessibilityIdentifier = "jobsTableView"

        didEdit = false

        tableView.refreshControl = refresher
        // Add Last Updated
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh jobs")
        refresher.addTarget(self, action: #selector(refreshJobs(_:)), for: .valueChanged)
    }

    @objc private func refreshJobs(_ sender: Any) {
        logger.info("-> Refreshing Job Data")

        var accounts: Results<Account>? {
            // Only Refresh Accounts that we want
            if let accountUUID = row?.accountUUID {
                return Account.allByUUID(provider: realm, uuid: accountUUID)
            } else {
                return Account.activeSorted(provider: realm)
            }
        }

        // Move to helper function
        for account in accounts! {
            var feed: RSSFeed!
            let feedService = FeedService(account: account)

            let feedURL = URLProvider(key: account.urlKey!).url()

            feedService.parser(url: feedURL)?.parseAsync(queue: DispatchQueue.global(qos: .userInitiated)) { (result) in
                feed = result.rssFeed!

                DispatchQueue.main.async {
                    feedService.save(realm: self.realm, feed: feed)

                    logger.info("-> Refreshed Job Data: \(String(describing: feed.items?.count))")

                    self.refresher.endRefreshing()
                    self.tableView.reloadData()
                }
            }
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        if didEdit {
            delegate?.didEdit()
        }
    }

    func segueSetup(row: Row) {
        self.row = row
        navigationItem.title = row.title
        navigationItem.leftItemsSupplementBackButton = true
    }
}

extension JobsTableViewController: JobViewControllerDelegate {
    func didChangeJob() {
        didEdit = true
        tableView.reloadData()
    }
}
