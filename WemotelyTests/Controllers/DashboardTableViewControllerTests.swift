import XCTest

@testable import Wemotely

class DashboardTableViewControllerTests: BaseTestCase {
    var tableViewController: DashboardTableViewController!

    func testTableViewAccessibilityIdentifierIsSet() {
        setup()
        XCTAssertNotNil(tableViewController.tableView.accessibilityIdentifier)
    }

    func testTableViewInsetsContentViewsToSafeArea() {
        setup()
        XCTAssertTrue(tableViewController.tableView.insetsContentViewsToSafeArea)
    }

    func testNavigationBarTitle() {
        setup()
        XCTAssertEqual(tableViewController.navigationItem.title, "Dashboard")
    }

    func testTableViewLoadingViewIsShownOnLoad() {
        setup()
        XCTAssertNotNil(tableViewController.tableView.backgroundView)
    }

    // MARK: - viewWillAppear

    func testViewWillAppearShowsTableView() {
        setup()

        let beforeLoad = tableViewController.tableView(tableViewController.tableView, numberOfRowsInSection: 0)
        XCTAssertEqual(beforeLoad, 0)

        tableViewController.viewDidAppear(false)

        let afterLoad = tableViewController.tableView(tableViewController.tableView, numberOfRowsInSection: 0)
        XCTAssertEqual(afterLoad, 10)
    }

    private func setup() {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)

        if let controller = storyboard.instantiateViewController(
            withIdentifier: "DashboardTableView"
            ) as? DashboardTableViewController {
            tableViewController = controller
            _ = tableViewController.view
        }
    }
}
