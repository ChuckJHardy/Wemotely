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
            let body = """
<style>
  #container {
    margin: 20px;
    font-family: Arial, Helvetica, sans-serif;
    font-size: 40px;
    line-height: 1.5;
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

    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
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

    private func setupToolbar() {
        let spacer = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: self,
            action: nil
        )

        let favouriteAction = UIBarButtonItem(
            image: UIImage(named: "heart"),
            style: .plain,
            target: self,
            action: #selector(favouriteJob(_:))
        )

        let deleteAction = UIBarButtonItem(
            image: UIImage(named: "trash"),
            style: .plain,
            target: self,
            action: #selector(deleteJob(_:))
        )

        let safariAction = UIBarButtonItem(
            title: "Open in Safari",
            style: .plain,
            target: self,
            action: #selector(openInSafari(_:))
        )

        self.toolbarItems = [safariAction, spacer, deleteAction, favouriteAction]
    }

    @objc private func favouriteJob(_ sender: Any) {
        logger.info("-> favouriteJob tapped")
    }

    @objc private func deleteJob(_ sender: Any) {
        logger.info("-> deleteJob tapped")
    }

    @objc private func openInSafari(_ sender: Any) {
        logger.info("-> openInSafari tapped")
    }

    func setupSegue(job: Job) {
        jobRecord = job

        if let split = splitViewController {
            navigationItem.leftItemsSupplementBackButton = true
            navigationItem.leftBarButtonItem = split.displayModeButtonItem
        }

        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.largeTitleDisplayMode = .never
    }
}
