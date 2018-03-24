import UIKit

extension DashboardTableViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showJobs"?:
            guard let controller = segue.destination as? JobsTableViewController else {
                return
            }

            if let indexPath = tableView.indexPathForSelectedRow {
                controller.segueSetup(row: getRow(indexPath: indexPath))
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
