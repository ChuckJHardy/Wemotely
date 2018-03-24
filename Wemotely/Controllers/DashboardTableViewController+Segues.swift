import UIKit

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
}
