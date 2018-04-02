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
    }

    override func viewWillAppear(_ animated: Bool) {
        fixNavigationItemHighlightBug()
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        loadJobs()
        tableView.reloadData()
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
        logger.info("-> Should Load Jobs on First Load")
    }
}

extension DashboardTableViewController: DashboardEditTableViewControllerDelegate, JobsTableViewControllerDelegate {
    func didEdit() {
        tableView.reloadData()
    }
}
