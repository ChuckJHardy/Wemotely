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
        handleSplitViewController()
    }

    override func viewWillAppear(_ animated: Bool) {
        fixNavigationItemHighlightBug()
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    private func getRow(indexPath: IndexPath) -> Row {
        return getSection(section: indexPath.section).rows[indexPath.row]
    }

    private func getSection(section: Int) -> Section {
        return sections[section]
    }

    private func handleSplitViewController() {
        if let split = splitViewController {
            let controllers = split.viewControllers

            guard let navigationController = controllers[controllers.count-1] as? UINavigationController else {
                return
            }

            jobViewController = navigationController.topViewController as? JobViewController
        }
    }

    // https://stackoverflow.com/questions/47805224/uibarbuttonitem-will-be-always-highlight-when-i-click-it
    private func fixNavigationItemHighlightBug() {
        navigationController?.navigationBar.tintAdjustmentMode = .normal
        navigationController?.navigationBar.tintAdjustmentMode = .automatic
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

extension DashboardTableViewController: DashboardEditTableViewControllerDelegate {
    func didEdit() {
        tableView.reloadData()
    }
}

extension DashboardTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getSection(section: section).rows.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DashboardTableViewCell.identifier, for: indexPath)

        if let dashboardCell = cell as? DashboardTableViewCell {
            let row = getRow(indexPath: indexPath)
            dashboardCell.setup(row: row)
            return dashboardCell
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionRecord = getSection(section: section)

        if sectionRecord.showHeader {
            return sectionRecord.heading
        }

        return nil
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
}
