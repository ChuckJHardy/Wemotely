import UIKit
import FeedKit
import RealmSwift

class DashboardTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    let realm = RealmProvider.realm()

    var jobViewController: JobViewController?

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingMessageLabel: UILabel!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!

    var accounts: Results<Account> {
        return Account.activeSorted(provider: realm)
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

        Seed(realm: realm).call(before: {
            logger.info("-> Seed.before")
            self.tableView.isHidden = true
            self.loadingMessageLabel.isHidden = false
            self.loadingIndicator.isHidden = false
            self.loadingIndicator.startAnimating()
        }, after: {
            logger.info("-> Seed.after")
            let accounts = Account.activeSorted(provider: realm)

            GetJobsService(privider: self.realm, accounts: accounts).call(perAccount: { (account) in
                do {
                    try self.realm.write {
                        account.lastUpdated = Date()
                    }
                } catch let err {
                    logger.error("Failed to update account lastUpdated", err)
                }
            }, completion: {
                UIView.animate(withDuration: 0.5, animations: {
                    self.loadingMessageLabel.isHidden = true
                    self.loadingIndicator.isHidden = true
                    self.loadingIndicator.stopAnimating()
                }, completion: { _ in
                    logger.info("-> Seed.completion")
                    self.tableView.reloadData()
                })
            })
        }, ensure: {
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
