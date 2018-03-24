import UIKit
import RealmSwift

class DashboardTableViewCell: UITableViewCell {
    static var identifier: String = "dashboardCell"

    func setup(provider: Realm, row: Row) {
        textLabel?.text = row.title

        // TODO: Refresh dashboard table when changes occur
        if let jobs = Job.byRowFilter(provider: provider, row: row) {
            detailTextLabel?.text = "\(jobs.count)"
        }

        imageView?.image = UIImage(named: row.icon)
    }
}
