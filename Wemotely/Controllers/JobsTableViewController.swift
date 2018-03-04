//
//  JobsTableViewController.swift
//  Wemotely
//
//  Created by Chuck J Hardy on 03/03/2018.
//  Copyright © 2018 Insert Coffee Limited. All rights reserved.
//

import UIKit

class JobsTableViewController: UITableViewController {
    var dashboardObject: Dashboard?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setToolbarHidden(true, animated: false)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showJob"?:
            if let indexPath = tableView.indexPathForSelectedRow {
                let controller = (segue.destination as! UINavigationController).topViewController as! JobViewController
                
                if let jobs = dashboardObject?.jobs {
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
        if let jobs = dashboardObject?.jobs {
            return jobs.count
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "jobsCell", for: indexPath)
        
        if let jobs = dashboardObject?.jobs {
            let object = jobs[indexPath.row]
            cell.textLabel!.text = object.title
        }
        
        return cell
    }
}
