import UIKit

class SettingsTableViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if !(splitViewController?.isCollapsed)! {
            performSegue(withIdentifier: "reshowDetailView", sender: self)
        }
    }
}
