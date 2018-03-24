import UIKit
import RealmSwift

class JobsTableViewController: UITableViewController {
    let realm = RealmProvider.realm()

    var accountObject: Account?

    var jobs: Results<Job>? {
        if let account = accountObject {
            return Job.unorganisedJobsByAccount(provider: realm, account: account)
        } else {
            return nil
        }
    }

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

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showJob"?:
            if let indexPath = tableView.indexPathForSelectedRow {
                guard let navigationController = segue.destination as? UINavigationController else {
                    return
                }

                if let controller = navigationController.topViewController as? JobViewController {
                    if let jobs = jobs {
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
