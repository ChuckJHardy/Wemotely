import UIKit
import RealmSwift

protocol JobsTableViewControllerDelegate: class {
    func didEdit()
}

class JobsTableViewController: UITableViewController {
    let realm = RealmProvider.realm()

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
