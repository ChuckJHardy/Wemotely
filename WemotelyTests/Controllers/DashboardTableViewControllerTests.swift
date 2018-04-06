import XCTest

@testable import Wemotely

class DashboardTableViewControllerTests: BaseTestCase {
    var tableViewController: DashboardTableViewController!

    override func setUp() {
        super.setUp()
        setup()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testControllerConfirmsToProtocols() {
        XCTAssert(tableViewController.conforms(to: UITableViewDataSource.self))
        XCTAssert(tableViewController.conforms(to: UITableViewDelegate.self))
    }

    func testTableViewDelegateIsSet() {
        XCTAssertNotNil(tableViewController.tableView.delegate)
    }

    func testTableViewDataSourceIsSet() {
        XCTAssertNotNil(tableViewController.tableView.dataSource)
    }

    func testTableViewAccessibilityIdentifierIsSet() {
        XCTAssertNotNil(tableViewController.tableView.accessibilityIdentifier)
    }

    func testTableViewInsetsContentViewsToSafeArea() {
        XCTAssertTrue(tableViewController.tableView.insetsContentViewsToSafeArea)
    }

    func testNavigationBarTitle() {
        XCTAssertEqual(tableViewController.navigationItem.title, "Dashboard")
    }

    func testTableViewIsHiddenByDefault() {
        XCTAssertTrue(tableViewController.tableView.isHidden)
    }

    private func setup() {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)

        if let controller = storyboard.instantiateViewController(
            withIdentifier: "DashboardTableViewController"
            ) as? DashboardTableViewController {
            tableViewController = controller
            _ = tableViewController.view
        }
    }
}
