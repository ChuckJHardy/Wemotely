import UIKit
import FeedKit
import RealmSwift

class DashboardTableViewController: UITableViewController {
    let realm = RealmProvider.realm()

    var jobViewController: JobViewController?

    var accounts: Results<Account> {
        return Account.activeSorted(provider: realm)
    }

    var sections: [Section] {
        return DashboardPresenter(accounts: accounts).present()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.accessibilityIdentifier = "dashboardTableView"

        setupNavigationbar()

        Seed(realm: realm).call()
        loadJobs()

        // navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem

        if let split = splitViewController {
            let controllers = split.viewControllers

            guard let navigationController = controllers[controllers.count-1] as? UINavigationController else {
                return
            }

            jobViewController = navigationController.topViewController as? JobViewController
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showJobs"?:
            if let indexPath = tableView.indexPathForSelectedRow {
                let accountObject = accounts[indexPath.row]

                guard let controller = segue.destination as? JobsTableViewController else {
                    return
                }

                // guard let navigationController = segue.destination as? UINavigationController else {
                //     return
                // }
                // let controller = navigationController.topViewController as? JobsTableViewController

                controller.accountObject = accountObject
                // controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        default:
            print("Missing Preperation for Segue \(String(describing: segue.identifier))")
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accounts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dashboardCell", for: indexPath)

        let object = accounts[indexPath.row]
        cell.textLabel!.text = object.title
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCellEditingStyle,
                            forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            do {
                try realm.write {
                    realm.delete(accounts[indexPath.row])
                }
            } catch let err {
                print("Failed to delete account: \(err)")
            }

            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class,
            // insert it into the array, and add a new row to the table view.
        }
    }

    private func setupNavigationbar() {
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
        performSegue(withIdentifier: "showFilter", sender: self)
    }

    func loadJobs() {
        let accounts = realm.objects(Account.self)

        for account in accounts {
            var feed: RSSFeed!
            let feedService = FeedService(account: account)

            let feedURL = URLProvider(key: account.urlKey!).url()

            feedService.parser(url: feedURL)?.parseAsync(queue: DispatchQueue.global(qos: .userInitiated)) { (result) in
                feed = result.rssFeed!

                DispatchQueue.main.async {
                    feedService.save(realm: self.realm, feed: feed)
                }
            }
        }
    }
}
