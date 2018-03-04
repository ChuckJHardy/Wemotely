import UIKit

class JobViewController: UIViewController {
    @IBOutlet weak var jobTitleDescriptionLabel: UILabel!
    
    func configureView() {
        if let job = jobRecord {
            self.title = job.title
            if let label = jobTitleDescriptionLabel {
                label.text = job.title
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
        configureView()
    }

    var jobRecord: Job? {
        didSet {
            configureView()
        }
    }
}
