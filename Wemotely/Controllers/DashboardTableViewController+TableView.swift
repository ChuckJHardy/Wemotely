import UIKit

extension DashboardTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let account = getSection(section: section) {
            return account.rows.count
        }

        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DashboardTableViewCell.identifier, for: indexPath)

        guard let dashboardCell = cell as? DashboardTableViewCell else {
            return cell
        }

        if let row = getRow(indexPath: indexPath) {
            dashboardCell.setup(provider: realmProvider, row: row)
            return dashboardCell
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let account = getSection(section: section) else {
            return nil
        }

        if account.showHeader {
            return account.heading
        }

        return nil
    }
}
