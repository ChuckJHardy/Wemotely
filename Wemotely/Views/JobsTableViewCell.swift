import UIKit

class JobsTableViewCell: UITableViewCell {
    static var identifier: String = "jobsCell"

    @IBOutlet weak var jobTitle: UILabel!
    @IBOutlet weak var jobSubtitle: UILabel!
    @IBOutlet weak var jobDescription: UILabel!
    @IBOutlet weak var stateImageView: UIImageView!

    func setup(job: Job) {
        stateImageView.accessibilityIdentifier = "stateImageView"
        stateImageView.isAccessibilityElement = true

        jobTitle?.text = job.title
        jobSubtitle?.text = job.company
        jobDescription?.text = JobPresenter().publishedAt(date: job.pubDate)

        if job.read {
            stateImageView.isHidden = true
            stateImageView?.image = nil
        } else {
            stateImageView.isHidden = false
            stateImageView?.image = UIImage(named: "unread-indicator")
        }
    }
}
