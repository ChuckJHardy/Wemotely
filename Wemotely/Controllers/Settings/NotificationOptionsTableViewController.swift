import UIKit

class NotificationOptionsTableViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
        navigationController?.setToolbarHidden(true, animated: false)
    }
}
