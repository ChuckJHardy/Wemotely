import UIKit

extension JobsTableViewController {
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
                    print("Failed to Delete Job: \(err)")
                }

                tableView.deleteRows(at: [indexPath], with: .fade)

                success(true)
            }

            success(false)
        }

        return UISwipeActionsConfiguration(actions: [action])
    }
}
