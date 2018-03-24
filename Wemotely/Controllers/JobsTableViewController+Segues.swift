import UIKit

extension JobsTableViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showJob"?:
            if let indexPath = tableView.indexPathForSelectedRow {
                guard let navigationController = segue.destination as? UINavigationController else {
                    return
                }

                if let controller = navigationController.topViewController as? JobViewController {
                    if let jobs = jobs {
                        let object = jobs[indexPath.row]
                        controller.jobRecord = object
                    }

                    controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                    controller.navigationItem.leftItemsSupplementBackButton = true
                }
            }
        default:
            print("Missing Preperation for Segue \(String(describing: segue.identifier))")
        }
    }
}
