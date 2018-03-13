import UIKit

protocol DashboardEditTableViewControllerDelegate: class {
    func didEdit()
}

class DashboardEditTableViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.accessibilityIdentifier = "editDashboardTableView"
    }
}
