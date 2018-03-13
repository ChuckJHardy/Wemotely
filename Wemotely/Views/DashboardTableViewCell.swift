import UIKit

class DashboardTableViewCell: UITableViewCell {
    static var identifier: String = "dashboardCell"

    func setupRow(title: String) {
        textLabel?.text = title
        detailTextLabel?.text = "0"
    }
}
