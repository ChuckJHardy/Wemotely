import UIKit
import FeedKit
import RealmSwift

class DashboardTableViewController: UITableViewController {
    var jobViewController: JobViewController?

    var accounts: Results<Account> {
        return Account.activeSorted(provider: realmProvider)
    }

    var sections: [Section] {
        return DashboardPresenter(accounts: accounts).present()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.accessibilityIdentifier = "dashboardTableView"

        setupNavigationbar()
        handleSplitViewController()
    }

    override func viewWillAppear(_ animated: Bool) {
        fixNavigationItemHighlightBug()
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        Seed(provider: realmProvider).call(before: {
            // Nothing yet
        }, after: {
            loadJobs()
        }, skipped: {
            // Nothing yet
        })
    }

    func getRow(indexPath: IndexPath) -> Row {
        return getSection(section: indexPath.section).rows[indexPath.row]
    }

    func getSection(section: Int) -> Section {
        return sections[section]
    }

    private func handleSplitViewController() {
        if let split = splitViewController {
            let controllers = split.viewControllers

            guard let navigationController = controllers[controllers.count-1] as? UINavigationController else {
                return
            }

            jobViewController = navigationController.topViewController as? JobViewController
        }
    }

    func loadJobs() {
        let accounts = realmProvider.objects(Account.self)

        for account in accounts {
            var feed: RSSFeed!
            let feedService = FeedService(account: account, updatedAt: Date())

            let feedURL = URLProvider(key: account.urlKey!).url()

            feedService.parser(url: feedURL)?.parseAsync(queue: DispatchQueue.global(qos: .userInitiated)) { (result) in
                feed = result.rssFeed!

                DispatchQueue.main.async {
                    feedService.save(realm: realmProvider, feed: feed)
                    self.tableView.reloadData()
                }
            }
        }
    }
}

extension DashboardTableViewController: DashboardEditTableViewControllerDelegate, JobsTableViewControllerDelegate {
    func didEdit() {
        tableView.reloadData()
    }
}
