import UIKit

class JobsTableViewCell: UITableViewCell {
    static var identifier: String = "jobCell"

    func setup(job: Job) {
        textLabel?.text = job.title
    }
}
