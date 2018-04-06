import UIKit
import RealmSwift

protocol DashboardEditTableViewControllerDelegate: class {
    func didEdit()
}

class DashboardEditTableViewController: UITableViewController {
    weak var delegate: DashboardTableViewController?
    var accounts: Results<Account> {
        return Account.allSorted(provider: realmProvider)
    }

    var didEdit: Bool = false {
        didSet {
            if didEdit {
                delegate?.didEdit()
            }
        }
    }

    var viewControllerInEditingMode: Bool = false {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.accessibilityIdentifier = "editDashboardTableView"

        setupNavigationbar()

        didEdit = false
    }

    func getAccount(indexPath: IndexPath) -> Account {
        return accounts[indexPath.row]
    }

    private func setupNavigationbar() {
        setEditing(false, animated: false)
        navigationItem.rightBarButtonItem = editButtonItem
    }
}

extension DashboardEditTableViewController: DashboardEditTableViewCellDelegate {
    var inEditingMode: Bool {
        get {
            return viewControllerInEditingMode
        }
        set {
            viewControllerInEditingMode = newValue
        }
    }

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)

        if editing {
            editButtonItem.title = "Done"
            inEditingMode = true
        } else {
            editButtonItem.title = "Reorder"
            inEditingMode = false
        }
    }

    func didTapSettingStateChange(requestedState: Bool, for account: Account) {
        do {
            try realmProvider.write { () -> Void in
                account.active = requestedState
                didEdit = true
            }
        } catch let err {
            logger.error("Account state '\(requestedState)' failed to change", err)
        }
    }
}
