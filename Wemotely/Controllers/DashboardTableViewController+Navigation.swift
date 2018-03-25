import UIKit

extension DashboardTableViewController {
    // https://stackoverflow.com/questions/47805224/uibarbuttonitem-will-be-always-highlight-when-i-click-it
    func fixNavigationItemHighlightBug() {
        navigationController?.navigationBar.tintAdjustmentMode = .normal
        navigationController?.navigationBar.tintAdjustmentMode = .automatic
    }

    func setupNavigationbar() {
        let editItem = UIBarButtonItem(
            title: "Edit",
            style: .plain,
            target: self,
            action: #selector(filterToolbarItemSelected(_:))
        )

        let settingsItem = UIBarButtonItem(
            title: "Settings",
            style: .plain,
            target: self,
            action: #selector(settingsToolbarItemSelected(_:))
        )

        navigationItem.leftBarButtonItem = settingsItem
        navigationItem.rightBarButtonItem = editItem
    }

    @objc private func settingsToolbarItemSelected(_ sender: Any) {
        performSegue(withIdentifier: "showSettings", sender: self)
    }

    @objc private func filterToolbarItemSelected(_ sender: Any) {
        performSegue(withIdentifier: "showDashboardEdit", sender: self)
    }
}
