import UIKit

extension JobsTableViewController {
    internal func forVisibleJob(block: (_ job: Job?) -> Void) {
        let secondaryAsNavController = splitViewController?.viewControllers.last as? UINavigationController
        if let topAsJobController = secondaryAsNavController?.topViewController as? JobViewController {
            block(topAsJobController.jobRecord)
        }
    }

    internal func selectCellForVisibleJob(cell: UITableViewCell, indexPath: IndexPath) {
        if let jobs = jobs {
            let job = jobs[indexPath.row]

            forVisibleJob { (otherJob) in
                if let otherJob = otherJob, otherJob.isEqual(job) {
                    previouslySelectedIndexPath = indexPath
                    cell.setSelected(true, animated: false)
                }
            }
        }
    }

    internal func deselectPreviouslySelectedCell() {
        if let index = previouslySelectedIndexPath {
            let previousCell = tableView.cellForRow(at: index)
            previousCell?.setSelected(false, animated: false)
        }
    }

    internal func setClearsSelection() {
        if let splitView = splitViewController {
            clearsSelectionOnViewWillAppear = splitView.isCollapsed
        }
    }
}
