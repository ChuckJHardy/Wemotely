import XCTest

@testable import Wemotely

class JobsTableViewControllerTests: BaseTestCase {
    var tableViewController: JobsTableViewController!

    var row: Row!
    let account = Account()

    func testTableViewDelegateIsSet() {
        setup(row: TestFixtures.Rows.trashedRow())
        XCTAssertNotNil(tableViewController.tableView.delegate)
    }

    func testTableViewAccessibilityIdentifierIsSet() {
        setup(row: TestFixtures.Rows.trashedRow())
        XCTAssertNotNil(tableViewController.tableView.accessibilityIdentifier)
    }

    func testDefaultDidEditValue() {
        setup(row: TestFixtures.Rows.trashedRow())
        XCTAssertFalse(tableViewController.didEdit)
    }

    // MARK: - Tableview Datasource

    func testTableViewNumberOfSections() {
        setup(row: TestFixtures.Rows.standardRow())
        let sectionsCount = tableViewController.numberOfSections(in: tableViewController.tableView)
        XCTAssertEqual(sectionsCount, 1)
    }

    func testTableViewRowCount() {
        setup(row: TestFixtures.Rows.standardRow(), job: TestFixtures.Jobs.unorganised(account: account))
        let cellsCount = tableViewController.tableView(tableViewController.tableView, numberOfRowsInSection: 0)
        XCTAssertEqual(cellsCount, 1)
    }

    func testTableViewWithoutJobsRowCount() {
        setup(row: TestFixtures.Rows.standardRow())
        let cellsCount = tableViewController.tableView(tableViewController.tableView, numberOfRowsInSection: 0)
        XCTAssertEqual(cellsCount, 0)
    }

    func testTableViewCellForRowAtWithoutAccount() {
        let indexPath = IndexPath(row: 0, section: 0)
        let job = TestFixtures.Jobs.unorganised(account: account)
        setup(row: TestFixtures.Rows.standardRow(), job: job)
        let cell = tableViewController.tableView(
            tableViewController.tableView, cellForRowAt: indexPath
        ) as? JobsTableViewCell

        XCTAssertEqual(cell?.accountName.text, job.account?.title)
        XCTAssertEqual(cell?.reuseIdentifier, JobsTableViewCell.identifier.withAccount)
    }

    func testTableViewCellForRowAtWithAccount() {
        let indexPath = IndexPath(row: 0, section: 0)
        let job = TestFixtures.Jobs.unorganised(account: account)
        setup(row: TestFixtures.Rows.unorganisedRow(accountUUID: account.uuid), job: job)
        let cell = tableViewController.tableView(
            tableViewController.tableView, cellForRowAt: indexPath
        ) as? JobsTableViewCell

        XCTAssertNil(cell?.accountName)
        XCTAssertEqual(cell?.reuseIdentifier, JobsTableViewCell.identifier.withoutAccount)
    }

    func testTableViewDidSelectRowAt() {
        let indexPath = IndexPath(row: 0, section: 0)
        let job = TestFixtures.Jobs.unorganised(account: account)

        setup(row: TestFixtures.Rows.standardRow(), job: job)

        XCTAssertFalse(job.read)
        XCTAssertFalse(tableViewController.didEdit)

        tableViewController.tableView(tableViewController.tableView, didSelectRowAt: indexPath)

        XCTAssertTrue(job.read)
        XCTAssertTrue(tableViewController.didEdit)
    }

    func testTableViewLeadingSwipeActionsConfigurationForRowAt() {
        let indexPath = IndexPath(row: 0, section: 0)
        let job = TestFixtures.Jobs.unorganised(account: account)
        setup(row: TestFixtures.Rows.standardRow(), job: job)

        let config = tableViewController.tableView(
            tableViewController.tableView,
            leadingSwipeActionsConfigurationForRowAt: indexPath
        )

        XCTAssertEqual(config?.actions.count, 1)
        XCTAssertEqual(config?.actions.first?.title, "Favourite")
    }

    func testTableViewLeadingSwipeActionsConfigurationForRowAtForFavouritedJob() {
        let indexPath = IndexPath(row: 0, section: 0)
        let job = TestFixtures.Jobs.favourited(account: account)
        setup(row: TestFixtures.Rows.favouritedRow(), job: job)

        let config = tableViewController.tableView(
            tableViewController.tableView,
            leadingSwipeActionsConfigurationForRowAt: indexPath
        )

        XCTAssertEqual(config?.actions.count, 1)
        XCTAssertEqual(config?.actions.first?.title, "Unfavourite")
    }

    func testTableViewTrailingSwipeActionsConfigurationForRowAt() {
        let indexPath = IndexPath(row: 0, section: 0)
        let job = TestFixtures.Jobs.unorganised(account: account)
        setup(row: TestFixtures.Rows.standardRow(), job: job)

        let config = tableViewController.tableView(
            tableViewController.tableView,
            trailingSwipeActionsConfigurationForRowAt: indexPath
        )

        XCTAssertEqual(config?.actions.count, 1)
        XCTAssertEqual(config?.actions.first?.title, "Delete")
    }

    func testTableViewTrailingSwipeActionsConfigurationForRowAtDeletedJob() {
        let indexPath = IndexPath(row: 0, section: 0)
        let job = TestFixtures.Jobs.trashed(account: account)
        setup(row: TestFixtures.Rows.trashedRow(), job: job)

        let config = tableViewController.tableView(
            tableViewController.tableView,
            trailingSwipeActionsConfigurationForRowAt: indexPath
        )

        XCTAssertEqual(config?.actions.count, 1)
        XCTAssertEqual(config?.actions.first?.title, "Undelete")
    }

    // MARK: - Seque Setup

    func testTableViewRowIsSet() {
        setup(row: TestFixtures.Rows.trashedRow())
        XCTAssertNotNil(tableViewController.row)
    }

    func testNavigationBarTitle() {
        setup(row: TestFixtures.Rows.trashedRow())
        XCTAssertEqual(tableViewController.navigationItem.title, Filter.trash.rawValue)
    }

    // MARK: - SplitViewController

    func testNavigationBarleftItemsSupplementBackButton() {
        setup(row: TestFixtures.Rows.trashedRow())
        XCTAssertTrue(tableViewController.navigationItem.leftItemsSupplementBackButton)
    }

    // MARK: - Refresher

    func testTableViewRefreshControlWhenRowIsNotRefreshable() {
        setup(row: TestFixtures.Rows.trashedRow())
        XCTAssertNil(tableViewController.tableView.refreshControl)
    }

    func testTableViewRefreshControlWhenRowIsRefreshable() {
        setup(row: TestFixtures.Rows.standardRow())
        XCTAssertNotNil(tableViewController.tableView.refreshControl)
        XCTAssertEqual(
            tableViewController.tableView.refreshControl?.attributedTitle,
            NSAttributedString(string: "Pull to refresh")
        )
    }

    // MARK: - Navigation Prompts

    func testTableViewNavigationPromptWithAccountLastUpdated() {
        let testDate = Date(timeInterval: 1000, since: Date())
        let job = TestFixtures.Jobs.unorganised(account: account)

        account.lastUpdated = testDate
        setup(row: TestFixtures.Rows.standardRow(), job: job)
        tableViewController.viewWillAppear(false)
        XCTAssertEqual(
            tableViewController.navigationItem.prompt,
            "Updated 16 minutes ago"
        )
    }

    func testTableViewNavigationPromptWithAccount() {
        let job = TestFixtures.Jobs.unorganised(account: account)

        setup(row: TestFixtures.Rows.standardRow(), job: job)
        tableViewController.viewWillAppear(false)
        XCTAssertNil(tableViewController.navigationItem.prompt)
    }

    func testTableViewNavigationPromptWithoutAccount() {
        setup(row: TestFixtures.Rows.standardRow())
        tableViewController.viewWillAppear(false)
        XCTAssertNil(tableViewController.navigationItem.prompt)
    }

    internal func setup(row: Row, job: Job? = nil) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)

        if let job = job {
            account.jobs.append(job)

            // swiftlint:disable:next force_try
            try! realm.write {
                realm.add(account, update: true)
            }
        }

        if let controller = storyboard.instantiateViewController(
            withIdentifier: "JobsTableView"
            ) as? JobsTableViewController {
            tableViewController = controller
            tableViewController.segueSetup(row: row)
            _ = tableViewController.view
        }
    }
}
