import UIKit
import WebKit

extension JobViewController {
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

    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        view = webView
    }

    func loadContent(job: Job) {
        var css: String = ""

        do {
            css = try String(contentsOf: FileLoader.load(name: "job", type: "css"))
        } catch let err {
            logger.error("Could not load job css", err)
        }

        let body = "<style>\(css)</style><div id='container'>\(job.body)<div>"
        webView.loadHTMLString(body, baseURL: nil)
    }
}
