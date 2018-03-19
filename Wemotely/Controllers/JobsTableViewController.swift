import UIKit

class JobsTableViewController: UITableViewController {
    let realm = RealmProvider.realm()

    var accountObject: Account?

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.accessibilityIdentifier = "jobsTableView"
    }
}

extension JobsTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let jobs = accountObject?.jobs {
            return jobs.count
        } else {
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: JobsTableViewCell.identifier, for: indexPath)

        if let jobCell = cell as? JobsTableViewCell {
            if let jobs = accountObject?.jobs {
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
            if let jobs = self.accountObject?.jobs {
                let job = jobs[indexPath.row]

                do {
                    try self.realm.write {
                        job.favourite = true
                    }
                } catch let err {
                    print("Failed to Favourite Job: \(err)")
                }

                tableView.reloadData()

                success(true)
            }

            success(false)
        }

        action.backgroundColor = UIColor.FlatColor.Blue.PictonBlue

        return UISwipeActionsConfiguration(actions: [action])
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showJob"?:
            if let indexPath = tableView.indexPathForSelectedRow {
                guard let navigationController = segue.destination as? UINavigationController else {
                    return
                }

                if let controller = navigationController.topViewController as? JobViewController {
                    if let jobs = accountObject?.jobs {
                        let object = jobs[indexPath.row]
                        controller.jobRecord = object
                    }

                    controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                    controller.navigationItem.leftItemsSupplementBackButton = true
                }
            }
        default:
            print("Missing Preperation for Segue \(String(describing: segue.identifier))")
        }
    }
}
