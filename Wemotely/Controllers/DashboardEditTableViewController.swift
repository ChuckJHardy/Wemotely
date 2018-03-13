import UIKit
import RealmSwift

protocol DashboardEditTableViewControllerDelegate: class {
    func didEdit()
}

class DashboardEditTableViewController: UITableViewController {
    let realm = RealmProvider.realm()

    weak var delegate: DashboardTableViewController?
    var accounts: Results<Account> {
        return Account.allSorted(provider: realm)
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

    private func getAccount(indexPath: IndexPath) -> Account {
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
            editButtonItem.title = "Reorder"
            inEditingMode = true
        } else {
            editButtonItem.title = "Reorder"
            inEditingMode = false
        }
    }

    func didTapSettingStateChange(requestedState: Bool, for account: Account) {
        do {
            try realm.write { () -> Void in
                account.active = requestedState
                didEdit = true
            }
        } catch let err {
            print("Failed to update Account active state: \(err)")
        }
    }
}

extension DashboardEditTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accounts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DashboardEditTableViewCell.identifier, for: indexPath)

        if let dashboardEditCell = cell as? DashboardEditTableViewCell {
            let account = getAccount(indexPath: indexPath)
            dashboardEditCell.delegate = self
            dashboardEditCell.setup(account: account)
            return dashboardEditCell
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView,
                            moveRowAt sourceIndexPath: IndexPath,
                            to destinationIndexPath: IndexPath) {

        do {
            try realm.write {
                let sourceObject = accounts[sourceIndexPath.row]
                let destinationObject = accounts[destinationIndexPath.row]

                let destinationObjectOrder = destinationObject.order

                if sourceIndexPath.row < destinationIndexPath.row {
                    for index in sourceIndexPath.row...destinationIndexPath.row {
                        let object = accounts[index]
                        object.order -= 1
                    }
                } else {
                    for index in (destinationIndexPath.row..<sourceIndexPath.row).reversed() {
                        let object = accounts[index]
                        object.order += 1
                    }
                }

                sourceObject.order = destinationObjectOrder

                didEdit = true
            }
        } catch let err {
            print("Failed to update Account order: \(err)")
        }
    }

    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func tableView(_ tableView: UITableView,
                            editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .none
    }
}
