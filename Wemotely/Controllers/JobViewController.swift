import UIKit

class JobViewController: UIViewController {
    @IBOutlet weak var jobTitleDescriptionLabel: UILabel!
    
    var jobRecord: Job? {
        didSet {
            configureView()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.accessibilityIdentifier = "jobTableView"
        
        navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
        configureView()
    }
    
    func configureView() {
        if let job = jobRecord {
            self.title = job.title
            if let label = jobTitleDescriptionLabel {
                label.text = job.title
            }
        }
    }
}
