import UIKit

extension JobViewController {
    func setupToolbar(job: Job) {
        let favouriteIcon = job.favourite ? "heart" : "unheart"
        let deleteText = job.trash ? "Undelete" : "Delete"

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
            title: deleteText,
            style: .plain,
            target: self,
            action: #selector(toggleDeleteJob(_:))
        )

        let safariAction = UIBarButtonItem(
            image: UIImage(named: "safari"),
            style: .plain,
            target: self,
            action: #selector(openInSafari(_:))
        )

        self.toolbarItems = [
            safariAction,
            spacer,
            favouriteAction,
            spacer,
            deleteAction
        ]

        navigationController?.setToolbarHidden(false, animated: true)
    }

    @objc private func toggleFavourite(_ sender: Any) {
        toggle(name: "favourite") { (job) in
            job.favourite = !job.favourite
        }
    }

    @objc private func toggleDeleteJob(_ sender: Any) {
        toggle(name: "delete") { (job) in
            job.trash = !job.trash
        }

        _ = navigationController?.navigationController?.popViewController(animated: true)
    }

    @objc private func openInSafari(_ sender: Any) {
        if let job = self.jobRecord, let link = job.link {
            let url = URL(string: link)
            UIApplication.shared.open(url!)
        }
    }

    private func toggle(name: String, block: (_ job: Job) -> Void) {
        if let job = self.jobRecord {
            do {
                try realmProvider.write {
                    block(job)

                    if splitViewController == nil {
                        didChangeJob = true
                    } else {
                        delegate?.didChangeJob()
                    }
                }
            } catch let err {
                logger.error("Failed to toggle action \(name) for Job", err)
            }

            setupToolbar(job: job)
        }
    }
}
