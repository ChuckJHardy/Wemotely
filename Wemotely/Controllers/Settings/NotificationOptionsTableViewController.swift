import UIKit

class NotificationOptionsTableViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Notification Options"
        navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
        navigationController?.setToolbarHidden(true, animated: false)
    }
}
