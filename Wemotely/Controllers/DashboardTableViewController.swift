import UIKit
import FeedKit
import RealmSwift

class DashboardTableViewController: UITableViewController {
    let realm = RealmProvider.realm()

    var jobViewController: JobViewController?

    var accounts: Results<Account> {
        return Account.activeSorted(provider: realm)
    }

    var sections: [Section] {
        return DashboardPresenter(accounts: accounts).present()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.accessibilityIdentifier = "dashboardTableView"

        setupNavigationbar()
        handleSplitViewController()

        Seed(realm: realm).call()
        loadJobs()
    }

    override func viewWillAppear(_ animated: Bool) {
        fixNavigationItemHighlightBug()
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
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
        let accounts = realm.objects(Account.self)

        for account in accounts {
            var feed: RSSFeed!
            let feedService = FeedService(account: account)

            let feedURL = URLProvider(key: account.urlKey!).url()

            feedService.parser(url: feedURL)?.parseAsync(queue: DispatchQueue.global(qos: .userInitiated)) { (result) in
                feed = result.rssFeed!

                DispatchQueue.main.async {
                    feedService.save(realm: self.realm, feed: feed)
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
