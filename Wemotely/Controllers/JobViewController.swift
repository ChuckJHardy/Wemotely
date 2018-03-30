import UIKit
import WebKit

class JobViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    @IBOutlet weak var jobTitleDescriptionLabel: UILabel!

    var webView: WKWebView!
    var jobRecord: Job!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.accessibilityIdentifier = "jobTableView"

        webView.allowsLinkPreview = false

        if let job = jobRecord {
            setupToolbar()

            self.title = job.company
            self.navigationItem.prompt = job.title

            loadContent(job: job)
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
    }
}
