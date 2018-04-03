import XCTest

@testable import Wemotely

class JobsTableViewControllerTests: BaseTestCase {
    var tableViewController: JobsTableViewController!

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testTableViewDelegateIsSet() {
        setup(row: TestFixtures.Rows.standardRow)
        XCTAssertNotNil(tableViewController.tableView.delegate)
    }

    func testTableViewAccessibilityIdentifierIsSet() {
        setup(row: TestFixtures.Rows.standardRow)
        XCTAssertNotNil(tableViewController.tableView.accessibilityIdentifier)
    }

    func testDefaultDidEditValue() {
        setup(row: TestFixtures.Rows.standardRow)
        XCTAssertFalse(tableViewController.didEdit)
    }

    // MARK: - Seque Setup

    func testTableViewRowIsSet() {
        setup(row: TestFixtures.Rows.standardRow)
        XCTAssertNotNil(tableViewController.row)
    }

    func testNavigationBarTitle() {
        setup(row: TestFixtures.Rows.standardRow)
        XCTAssertEqual(tableViewController.navigationItem.title, Filter.inbox.rawValue)
    }

    // MARK: - SplitViewController

    func testNavigationBarleftItemsSupplementBackButton() {
        setup(row: TestFixtures.Rows.standardRow)
        XCTAssertTrue(tableViewController.navigationItem.leftItemsSupplementBackButton)
    }

    // MARK: - Refresher

    func testTableViewRefreshControlWhenRowIsNotRefreshable() {
        setup(row: TestFixtures.Rows.standardRow)
        XCTAssertNil(tableViewController.tableView.refreshControl)
    }

    func testTableViewRefreshControlWhenRowIsRefreshable() {
        setup(row: TestFixtures.Rows.refreshableRow)
        XCTAssertNotNil(tableViewController.tableView.refreshControl)
        XCTAssertEqual(
            tableViewController.tableView.refreshControl?.attributedTitle,
            NSAttributedString(string: "Pull to refresh")
        )
    }

    private func setup(row: Row) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)

        if let controller = storyboard.instantiateViewController(
            withIdentifier: "JobsTableViewController"
            ) as? JobsTableViewController {
            tableViewController = controller
            tableViewController.realm = realm
            tableViewController.segueSetup(row: row)
            _ = tableViewController.view
        }
    }
}
