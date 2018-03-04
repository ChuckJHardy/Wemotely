import UIKit

class NotificationOptionsTableViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Notification Options"
        
        if (splitViewController?.isCollapsed)! {
            navigationItem.leftItemsSupplementBackButton = true
        }
        
        navigationController?.setToolbarHidden(true, animated: false)
    }
}
