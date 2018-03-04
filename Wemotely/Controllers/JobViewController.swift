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
        navigationController?.setToolbarHidden(true, animated: false)
        navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
        configureView()
    }

    var jobRecord: String? {
        didSet {
            configureView()
        }
    }
}
