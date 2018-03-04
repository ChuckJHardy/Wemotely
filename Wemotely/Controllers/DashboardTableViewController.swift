import UIKit

class DashboardTableViewController: UITableViewController {
    var jobViewController: JobViewController? = nil
    var objects: [Job] = [
        Job(title: "Engineer"),
        Job(title: "Manager"),
        Job(title: "Astronaut")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupToolbar()
        showToolbar()
        
        navigationItem.leftBarButtonItem = editButtonItem
        
        // navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem

        if let split = splitViewController {
            let controllers = split.viewControllers
            jobViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? JobViewController
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        showToolbar()
        super.viewWillAppear(animated)
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showDetail"?:
            if let indexPath = tableView.indexPathForSelectedRow {
                let object = objects[indexPath.row]
                let controller = (segue.destination as! UINavigationController).topViewController as! JobViewController
                controller.jobRecord = object.title
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
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
        return objects.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let object = objects[indexPath.row]
        cell.textLabel!.text = object.title
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            objects.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
    private func showToolbar() {
        navigationController?.setToolbarHidden(false, animated: false)
    }
    
    private func setupToolbar() {
        let spacer = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: self,
            action: nil
        )
        
        let filterItem = UIBarButtonItem(
            title: "Filter",
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
        
        toolbarItems = [filterItem, spacer, settingsItem]
    }
    
    @objc private func settingsToolbarItemSelected(_ sender: Any) {
        performSegue(withIdentifier: "showSettings", sender: self)
    }
    
    @objc private func filterToolbarItemSelected(_ sender: Any) {
        performSegue(withIdentifier: "showFilter", sender: self)
    }
}
