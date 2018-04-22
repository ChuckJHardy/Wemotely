import UIKit
import RealmSwift

protocol JobsTableViewControllerDelegate: class {
    func didEdit()
}

class JobsTableViewController: UITableViewController {
    internal let refresher = UIRefreshControl()
    weak var delegate: DashboardTableViewController?
    var row: Row?
    var didEdit: Bool = false
    var previouslySelectedIndexPath: IndexPath?

    var jobs: Results<Job>? {
        return Job.byRowFilter(provider: realmProvider, row: row)
    }

    var accounts: Results<Account>? {
        return Account.refreshable(provider: realmProvider, uuid: row?.accountUUID)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.accessibilityIdentifier = "jobsTableView"

        didEdit = false

        setupRefreshControl()
        setupToolbar()
    }

    override func viewWillAppear(_ animated: Bool) {
        updateNavigationPromptFromAccounts()
        setClearsSelection()
        super.viewWillAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        preferLargeTitles()

        if didEdit {
            delegate?.didEdit()
        }
    }

    func segueSetup(row: Row) {
        self.row = row
        navigationItem.title = row.title
        navigationItem.leftItemsSupplementBackButton = true
        preferSmallTitles()
    }

    func accountURL() -> URL {
        if row?.accountUUID != nil, let account = self.accounts?.first {
            return URLProviderFactory(isTesting: false).build(key: account.urlKey!).url()
        } else {
            return BaseURLProvider.baseUrl()
        }
    }

    private func preferSmallTitles() {
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.largeTitleDisplayMode = .never
    }

    private func preferLargeTitles() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
    }

    internal func runWhenRefreshable(block: (_ row: Row) -> Void) {
        if let row = row, row.refreshable {
            block(row)
        }
    }
}

extension JobsTableViewController: JobViewControllerDelegate {
    func didChangeJob() {
        didEdit = true
        tableView.reloadData()
    }
}
