import UIKit

class JobsTableViewCell: UITableViewCell {
    static var identifier: String = "jobsCell"

    func setup(job: Job) {
        textLabel?.text = job.title
        detailTextLabel?.text = job.company
    }
}
