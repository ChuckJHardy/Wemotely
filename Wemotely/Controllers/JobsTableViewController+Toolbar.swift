import UIKit

extension JobsTableViewController {
    func setupToolbar() {
        let spacer = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: self,
            action: nil
        )

        let safariAction = UIBarButtonItem(
            image: UIImage(named: "safari"),
            style: .plain,
            target: self,
            action: #selector(openInSafari(_:))
        )

        self.toolbarItems = [
            safariAction,
            spacer
        ]

        navigationController?.setToolbarHidden(false, animated: true)
    }

    @objc private func openInSafari(_ sender: Any) {
        UIApplication.shared.open(accountURL())
    }
}
