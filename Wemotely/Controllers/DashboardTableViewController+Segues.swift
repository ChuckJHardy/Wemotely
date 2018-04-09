import UIKit

extension DashboardTableViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showJobs"?:
            guard let controller = segue.destination as? JobsTableViewController else {
                return
            }

            controller.delegate = self

            guard let indexPath = tableView.indexPathForSelectedRow else {
                return
            }

            if let row = getRow(indexPath: indexPath) {
                controller.segueSetup(row: row)
            }
        case "showDashboardEdit"?:
            guard let controller = segue.destination as? DashboardEditTableViewController else {
                return
            }

            controller.delegate = self
        default:
            logger.warning("Missing Segue", segue.identifier!)
        }
    }
}
