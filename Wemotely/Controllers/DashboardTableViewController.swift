import UIKit
import FeedKit
import RealmSwift

class DashboardTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var jobViewController: JobViewController?

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingMessageLabel: UILabel!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!

    var accounts: Results<Account> {
        return Account.activeSorted(provider: realmProvider)
    }

    var sections: [Section] {
        return DashboardPresenter(accounts: accounts).present()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.insetsContentViewsToSafeArea = true

        tableView.accessibilityIdentifier = "dashboardTableView"
        loadingMessageLabel.accessibilityIdentifier = "loadingMessage"
        loadingIndicator.accessibilityIdentifier = "loadingIndicator"

        self.tableView.isHidden = true

        setupNavigationbar()
        setupSplitViewController()
    }

    override func viewWillAppear(_ animated: Bool) {
        fixNavigationItemHighlightBug()
        // clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        Seed(realm: realmProvider).call(before: {
            self.tableView.isHidden = true
            self.loadingMessageLabel.isHidden = false
            self.loadingIndicator.isHidden = false
            self.loadingIndicator.startAnimating()
        }, after: {
            GetJobsService(accounts: accounts).call(completion: { _ in
                self.tableView.reloadData()
                self.loadingMessageLabel.isHidden = true
                self.loadingIndicator.isHidden = true
                self.tableView.isHidden = false
                self.loadingIndicator.stopAnimating()
            })
        }, skipped: {
            self.tableView.isHidden = false
        })
    }

    func getRow(indexPath: IndexPath) -> Row {
        return getSection(section: indexPath.section).rows[indexPath.row]
    }

    func getSection(section: Int) -> Section {
        return sections[section]
    }

    private func setupSplitViewController() {
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
