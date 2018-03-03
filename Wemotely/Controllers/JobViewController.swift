import UIKit

class JobViewController: UIViewController {
    @IBOutlet weak var jobTitleDescriptionLabel: UILabel!
    
    func configureView() {
        if let job = jobRecord {
            if let label = jobTitleDescriptionLabel {
                label.text = job.description
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }

    var jobRecord: String? {
        didSet {
            configureView()
        }
    }
}
