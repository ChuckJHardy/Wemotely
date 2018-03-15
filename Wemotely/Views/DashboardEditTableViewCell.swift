import UIKit

protocol DashboardEditTableViewCellDelegate: class {
    var inEditingMode: Bool { get set }
    func didTapSettingStateChange(requestedState: Bool, for account: Account)
}

class DashboardEditTableViewCell: UITableViewCell {
    static var identifier: String = "dashboardEditCell"

    var accountRecord: Account!
    weak var delegate: DashboardEditTableViewController?

    @IBOutlet weak var stateSwitch: UISwitch!
    @IBOutlet weak var accountLabel: UILabel!

    func setup(account: Account) {
        accountRecord = account
        accountLabel.text = account.title
        selectionStyle = .none
        setDetailTextLabelVisibility()
        stateSwitch.setOn(account.active, animated: false)
    }

    func setDetailTextLabelVisibility() {
        if (delegate?.inEditingMode)! {
            stateSwitch?.isHidden = true
        } else {
            stateSwitch?.isHidden = false
        }
    }

    @IBAction func stateSwitchValueChanged(_ sender: UISwitch) {
        delegate?.didTapSettingStateChange(requestedState: sender.isOn, for: accountRecord)
    }
}
