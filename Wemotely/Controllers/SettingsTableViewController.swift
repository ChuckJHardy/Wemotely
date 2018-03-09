import UIKit

class SettingsTableViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.accessibilityIdentifier = "settingsTableView"
    }

    override func viewWillDisappear(_ animated: Bool) {
        if !(splitViewController?.isCollapsed)! {
            performSegue(withIdentifier: "reshowDetailView", sender: self)
        }
    }
}
