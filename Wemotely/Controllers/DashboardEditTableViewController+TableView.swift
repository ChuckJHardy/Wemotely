import UIKit

extension DashboardEditTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accounts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DashboardEditTableViewCell.identifier, for: indexPath)

        if let dashboardEditCell = cell as? DashboardEditTableViewCell {
            let account = getAccount(indexPath: indexPath)
            dashboardEditCell.delegate = self
            dashboardEditCell.setup(account: account)
            return dashboardEditCell
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView,
                            moveRowAt sourceIndexPath: IndexPath,
                            to destinationIndexPath: IndexPath) {

        do {
            try realmProvider.write {
                let sourceObject = accounts[sourceIndexPath.row]
                let destinationObject = accounts[destinationIndexPath.row]

                let destinationObjectOrder = destinationObject.order

                if sourceIndexPath.row < destinationIndexPath.row {
                    for index in sourceIndexPath.row...destinationIndexPath.row {
                        let object = accounts[index]
                        object.order -= 1
                    }
                } else {
                    for index in (destinationIndexPath.row..<sourceIndexPath.row).reversed() {
                        let object = accounts[index]
                        object.order += 1
                    }
                }

                sourceObject.order = destinationObjectOrder

                didEdit = true
            }
        } catch let err {
            logger.error("Account failed to change order", err)
        }
    }

    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func tableView(_ tableView: UITableView,
                            editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .none
    }
}
