import UIKit
import RealmSwift

protocol JobsTableViewControllerDelegate: class {
    func didEdit()
}

class JobsTableViewController: UITableViewController {
    weak var delegate: DashboardTableViewController?
    var row: Row?
    var didEdit: Bool = false

    var jobs: Results<Job>? {
        return Job.byRowFilter(provider: realmProvider, row: row)
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

extension JobsTableViewController: JobViewControllerDelegate {
    func didChangeJob() {
        didEdit = true
        tableView.reloadData()
    }
}
