import UIKit

class JobsTableViewController: UITableViewController {
    var accountObject: Account?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.accessibilityIdentifier = "jobsTableView"
    }
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showJob"?:
            if let indexPath = tableView.indexPathForSelectedRow {
                let controller = (segue.destination as! UINavigationController).topViewController as! JobViewController
                
                if let jobs = accountObject?.jobs {
                    let object = jobs[indexPath.row]
                    controller.jobRecord = object
                }
                
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        default:
            print("Missing Preperation for Segue \(String(describing: segue.identifier))")
        }
    }

    // MARK: - Table view data source

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
        let cell = tableView.dequeueReusableCell(withIdentifier: "jobsCell", for: indexPath)
        
        if let jobs = accountObject?.jobs {
            let object = jobs[indexPath.row]
            cell.textLabel!.text = object.title
        }
        
        return cell
    }
}
