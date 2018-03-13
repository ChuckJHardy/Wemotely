import UIKit

class DashboardTableViewCell: UITableViewCell {
    static var identifier: String = "dashboardCell"

    func setup(row: Row) {
        textLabel?.text = row.title
        detailTextLabel?.text = "0"
    }
}
