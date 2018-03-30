import UIKit

extension JobViewController {
    func setupToolbar(job: Job) {
        let favouriteIcon = job.favourite ? "heart" : "unheart"

        let spacer = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: self,
            action: nil
        )

        let favouriteAction = UIBarButtonItem(
            image: UIImage(named: favouriteIcon),
            style: .plain,
            target: self,
            action: #selector(toggleFavourite(_:))
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

        self.toolbarItems = [
            safariAction,
            spacer,
            deleteAction,
            favouriteAction
        ]
    }

    @objc private func toggleFavourite(_ sender: Any) {
        logger.info("-> toggleFavourite tapped")

        if let job = jobRecord {
            do {
                try self.realm.write {
                    job.favourite = !job.favourite
                    didChangeJob = true
                }
            } catch let err {
                logger.error("Failed to toggle favourite for Job", err)
            }

            setupToolbar(job: job)
        }
    }

    @objc private func deleteJob(_ sender: Any) {
        logger.info("-> deleteJob tapped")
    }

    @objc private func openInSafari(_ sender: Any) {
        logger.info("-> openInSafari tapped")
    }
}
