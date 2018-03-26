import UIKit
import WebKit

class JobViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    @IBOutlet weak var jobTitleDescriptionLabel: UILabel!

    var webView: WKWebView!
    var jobRecord: Job!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.accessibilityIdentifier = "jobTableView"

        navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem

        webView.allowsLinkPreview = false

        if let job = jobRecord {
            self.title = job.company
            self.navigationItem.prompt = job.title
            let body = """
<style>
  #container {
    width: 95%;
    margin: 20px;
    font-family: Arial, Helvetica, sans-serif;
    font-size: 2.5em;
    line-height: 1.5em;
  }

  #container img {
    display: block;
    margin-left: auto;
    margin-right: auto;
    margin-bottom: 30px;
    width: 50%;
  }

  #container a, #container a:visited {
    color: #39c;
    text-decoration: none;
  }
</style>

<div id="container">
\(job.body)
<div>
"""
            webView.loadHTMLString(body, baseURL: nil)
        }
    }

    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        view = webView
    }

    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        logger.info("-> Schema: \(String(describing: navigationAction.request.url?.scheme))")

        if navigationAction.navigationType == .linkActivated {
            if let url = navigationAction.request.url, UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
                decisionHandler(.cancel)
            } else {
                decisionHandler(.allow)
            }
        } else {
            decisionHandler(.allow)
        }
    }
}
