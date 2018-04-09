import UIKit

class LoadingEmptyStateView: UIView {
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var label: UILabel!

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setupView()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    func setupView() {
        Bundle.main.loadNibNamed("LoadingEmptyStateView", owner: self, options: nil)
        view.frame = self.frame
        addSubview(view)
    }

    func show(tableView: UITableView) {
        indicator.startAnimating()
        tableView.backgroundView = self
    }

    func hide(tableView: UITableView) {
        indicator.stopAnimating()
        tableView.backgroundView = nil
    }
}
