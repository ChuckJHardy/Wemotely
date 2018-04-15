import UIKit

extension JobsTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let jobs = jobs {
            return jobs.count
        } else {
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: JobsTableViewCell.identifier, for: indexPath)

        if let jobCell = cell as? JobsTableViewCell {
            if let jobs = jobs {
                jobCell.setup(job: jobs[indexPath.row])
            }

            return jobCell
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let jobs = jobs {
            Job.markAsRead(provider: realmProvider, job: jobs[indexPath.row])
            didChangeJob()
        }
    }

    override func tableView(
        _ tableView: UITableView,
        leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath
        ) -> UISwipeActionsConfiguration? {
        var job: Job!
        var title: String = "Favourite"

        if let jobs = self.jobs {
            job = jobs[indexPath.row]
            title = job.favourite ? "Unfavourite" : title

            // swiftlint:disable:next line_length
            let action = UIContextualAction(style: .normal, title: title) { (_ context: UIContextualAction, _ view: UIView, success: (Bool) -> Void) in
                do {
                    try realmProvider.write {
                        job.favourite = !job.favourite
                        job.trash = false
                        self.didEdit = true
                    }

                    tableView.deleteRows(at: [indexPath], with: .fade)
                } catch let err {
                    logger.error("Job failed to favourite", err)
                    success(false)
                }

                success(true)
            }

            action.backgroundColor = UIColor.CustomColor.Apple.Blue

            return UISwipeActionsConfiguration(actions: [action])
        }

        return UISwipeActionsConfiguration(actions: [])
    }

    override func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
        ) -> UISwipeActionsConfiguration? {
        var job: Job!
        var title: String = "Delete"

        if let jobs = self.jobs {
            job = jobs[indexPath.row]
            title = job.trash ? "Undelete" : title

            // swiftlint:disable:next line_length
            let action = UIContextualAction(style: .destructive, title: title) { (_ context: UIContextualAction, _ view: UIView, success: (Bool) -> Void) in
                do {
                    try realmProvider.write {
                        job.trash = !job.trash
                        job.favourite = false
                        self.didEdit = true
                    }

                    tableView.deleteRows(at: [indexPath], with: .fade)
                } catch let err {
                    logger.error("Job failed to delete", err)
                    success(false)
                }

                success(true)
            }

            return UISwipeActionsConfiguration(actions: [action])
        }

        return UISwipeActionsConfiguration(actions: [])
    }
}
