import UIKit
import WebKit

protocol JobViewControllerDelegate: class {
    func didChangeJob()
}

class JobViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    @IBOutlet weak var jobTitleDescriptionLabel: UILabel!

    let realm = RealmProvider.realm()

    weak var delegate: JobsTableViewController?
    var didChangeJob: Bool = false
    var webView: WKWebView!
    var jobRecord: Job!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.accessibilityIdentifier = "jobTableView"

        if let split = splitViewController {
            navigationItem.leftItemsSupplementBackButton = true
            navigationItem.leftBarButtonItem = split.displayModeButtonItem
        }

        didChangeJob = false
        webView.allowsLinkPreview = false

        if let job = jobRecord {
            loadContent(job: job)
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setToolbarHidden(true, animated: false)

        if didChangeJob {
            delegate?.didChangeJob()
        }
    }
}
