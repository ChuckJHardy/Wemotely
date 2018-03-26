import UIKit
import WebKit

class JobViewController: UIViewController, WKUIDelegate {
    @IBOutlet weak var jobTitleDescriptionLabel: UILabel!

    var webView: WKWebView!
    var jobRecord: Job!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.accessibilityIdentifier = "jobTableView"

        navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem

        webView.allowsLinkPreview = true

        if let job = jobRecord {
            self.title = job.company
            self.navigationItem.prompt = job.title
            webView.loadHTMLString(job.body, baseURL: nil)
        }
    }

    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
}
