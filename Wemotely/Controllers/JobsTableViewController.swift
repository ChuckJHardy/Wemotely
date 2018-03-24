import UIKit
import RealmSwift

class JobsTableViewController: UITableViewController {
    let realm = RealmProvider.realm()

    var accountObject: Account?

    var jobs: Results<Job>? {
        if let account = accountObject {
            return Job.unorganisedJobsByAccount(provider: realm, account: account)
        } else {
            return nil
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.accessibilityIdentifier = "jobsTableView"
    }
}
