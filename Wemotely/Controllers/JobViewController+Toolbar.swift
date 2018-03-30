import UIKit

extension JobViewController {
    func setupToolbar() {
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
}
