import UIKit
import RealmSwift

class DashboardTableViewCell: UITableViewCell {
    static var identifier: String = "dashboardCell"

    func setup(provider: Realm, row: Row) {
        textLabel?.text = row.title

        if let jobs = Job.byRowFilter(provider: provider, row: row) {
            detailTextLabel?.text = "\(jobs.count)"
        }

        imageView?.image = UIImage(named: row.icon)
    }
}
