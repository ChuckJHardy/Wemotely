import UIKit
import FeedKit
import RealmSwift

class DashboardTableViewController: UITableViewController {
    var jobViewController: JobViewController?
    var loadingView: LoadingEmptyStateView = LoadingEmptyStateView()

    var accounts: Results<Account> {
        return Account.activeSorted(provider: realmProvider)
    }

    var sections: [Section] {
        if accounts.count > 0 {
            return DashboardPresenter(accounts: accounts).present()
        }

        return []
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.accessibilityIdentifier = "dashboardTableView"

        setupNavigationbar()
        handleSplitViewController()

        loadingView.show(tableView: tableView)
    }

    override func viewWillAppear(_ animated: Bool) {
        fixNavigationItemHighlightBug()
        navigationController?.setToolbarHidden(true, animated: false)
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        Seed(provider: realmProvider).call(before: {
            self.loadingView.show(tableView: self.tableView)
        }, after: {
            GetJobsService(accounts: accounts).call(completion: { _ in
                self.handleDataUpdate()
            })
        }, skipped: {
            self.loadingView.hide(tableView: self.tableView)
        })
    }

    func getRow(indexPath: IndexPath) -> Row? {
        if let section = getSection(section: indexPath.section) {
            return section.rows[indexPath.row]
        }

        return nil
    }

    func getSection(section: Int) -> Section? {
        if sections.isEmpty {
            return nil
        } else {
            return sections[section]
        }
    }

    func handleDataUpdate() {
        self.tableView.reloadData()
        self.loadingView.hide(tableView: self.tableView)
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
}

extension DashboardTableViewController: DashboardEditTableViewControllerDelegate, JobsTableViewControllerDelegate {
    func didEdit() {
        tableView.reloadData()
    }
}
