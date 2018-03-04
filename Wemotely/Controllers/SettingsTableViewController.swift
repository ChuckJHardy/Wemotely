import UIKit

class SettingsTableViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setToolbarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if !(splitViewController?.isCollapsed)! {
            performSegue(withIdentifier: "reshowDetailView", sender: self)
        }
    }
}
