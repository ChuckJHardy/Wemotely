import UIKit

extension DashboardTableViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showJobs"?:
            guard let controller = segue.destination as? JobsTableViewController else {
                return
            }

            if let indexPath = tableView.indexPathForSelectedRow {
                controller.accountObject = accounts[indexPath.row]
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        case "showDashboardEdit"?:
            guard let controller = segue.destination as? DashboardEditTableViewController else {
                return
            }

            controller.delegate = self
        default:
            print("Missing Preperation for Segue \(String(describing: segue.identifier))")
        }
    }
}
