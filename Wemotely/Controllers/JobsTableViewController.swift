import UIKit
import RealmSwift

class JobsTableViewController: UITableViewController {
    let realm = RealmProvider.realm()

    var row: Row?

    var jobs: Results<Job>? {
        return Job.byRowFilter(provider: realm, row: row)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.accessibilityIdentifier = "jobsTableView"
    }
}
