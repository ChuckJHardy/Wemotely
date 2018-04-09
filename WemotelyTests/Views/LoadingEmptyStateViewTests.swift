import XCTest

@testable import Wemotely

class LoadingEmptyStateViewTests: BaseTestCase {
    var view: LoadingEmptyStateView!
    var tableView: UITableView!

    func testSetupView() {
        setup()
        XCTAssertNotNil(view.frame)
    }

    func testShow() {
        setup()
        XCTAssertNil(tableView.backgroundView)
        view.show(tableView: tableView)
        XCTAssertEqual(tableView.backgroundView, view)
    }

    func testHide() {
        setup()
        XCTAssertNil(tableView.backgroundView)
        tableView.backgroundView = view
        view.hide(tableView: tableView)
        XCTAssertNil(tableView.backgroundView)
    }

    private func setup() {
        view = LoadingEmptyStateView(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: 1, height: 1), style: .grouped)
    }
}
