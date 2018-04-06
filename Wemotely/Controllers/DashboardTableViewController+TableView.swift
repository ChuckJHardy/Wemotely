import UIKit

extension DashboardTableViewController {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getSection(section: section).rows.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DashboardTableViewCell.identifier, for: indexPath)

        if let dashboardCell = cell as? DashboardTableViewCell {
            let row = getRow(indexPath: indexPath)
            dashboardCell.setup(provider: realmProvider, row: row)
            return dashboardCell
        }

        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionRecord = getSection(section: section)

        if sectionRecord.showHeader {
            return sectionRecord.heading
        }

        return nil
    }
}
