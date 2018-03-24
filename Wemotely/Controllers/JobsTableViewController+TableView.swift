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

    override func tableView(
        _ tableView: UITableView,
        leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath
        ) -> UISwipeActionsConfiguration? {
        // swiftlint:disable:next line_length
        let action = UIContextualAction(style: .normal, title: "Favourite") { (_ context: UIContextualAction, _ view: UIView, success: (Bool) -> Void) in
            if let jobs = self.jobs {
                let job = jobs[indexPath.row]

                do {
                    try self.realm.write {
                        job.favourite = true
                    }
                } catch let err {
                    print("Failed to Favourite Job: \(err)")
                }

                tableView.deleteRows(at: [indexPath], with: .fade)

                success(true)
            }

            success(false)
        }

        action.backgroundColor = UIColor.CustomColor.Apple.Blue

        return UISwipeActionsConfiguration(actions: [action])
    }

    override func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
        ) -> UISwipeActionsConfiguration? {
        // swiftlint:disable:next line_length
        let action = UIContextualAction(style: .destructive, title: "Delete") { (_ context: UIContextualAction, _ view: UIView, success: (Bool) -> Void) in
            if let jobs = self.jobs {
                let job = jobs[indexPath.row]

                do {
                    try self.realm.write {
                        job.trash = true
                    }
                } catch let err {
                    logger.error("Job failed to delete", err)
                }

                tableView.deleteRows(at: [indexPath], with: .fade)

                success(true)
            }

            success(false)
        }

        return UISwipeActionsConfiguration(actions: [action])
    }
}
