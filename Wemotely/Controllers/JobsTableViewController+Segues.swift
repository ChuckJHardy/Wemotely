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
                        controller.setupSegue(job: jobs[indexPath.row])
                        controller.delegate = self
                    }
                }
            }
        default:
            print("Missing Preperation for Segue \(String(describing: segue.identifier))")
        }
    }
}
