import XCTest

@testable import Wemotely

class JobsTableViewControllerTests: BaseTestCase {
    var tableViewController: JobsTableViewController!

    override func setUp() {
        super.setUp()

        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)

        if let controller = storyboard.instantiateViewController(
            withIdentifier: "JobsTableViewController"
        ) as? JobsTableViewController {
            tableViewController = controller
            tableViewController.realm = realm
            tableViewController.segueSetup(row: TestFixtures.Rows.standardRow)
            _ = tableViewController.view
        }
    }

    override func tearDown() {
        super.tearDown()
    }

    func testTableViewDelegateIsSet() {
        XCTAssertNotNil(tableViewController.tableView.delegate)
    }

    func testTableViewAccessibilityIdentifierIsSet() {
        XCTAssertNotNil(tableViewController.tableView.accessibilityIdentifier)
    }

    func testDefaultDidEditValue() {
        XCTAssertFalse(tableViewController.didEdit)
    }

    // MARK: - Seque Setup

    func testTableViewRowIsSet() {
        XCTAssertNotNil(tableViewController.row)
    }

    func testNavigationBarTitle() {
        XCTAssertEqual(tableViewController.navigationItem.title, Filter.favourites.rawValue)
    }

    // MARK: - SplitViewController

    func testNavigationBarleftItemsSupplementBackButton() {
        XCTAssertTrue(tableViewController.navigationItem.leftItemsSupplementBackButton)
    }
}
