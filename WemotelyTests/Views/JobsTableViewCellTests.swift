import XCTest

@testable import Wemotely

class JobsTableViewCellTests: BaseTestCase {
    var tableViewController: JobsTableViewController!
    var tableViewCell: JobsTableViewCell!

    var row: Row!
    let account = Account()

    func testJobTitle() {
        let job = TestFixtures.Jobs.unorganised(account: account)
        setup(row: TestFixtures.Rows.standardRow(), job: job)

        XCTAssertEqual(tableViewCell?.jobTitle.text, job.title)
    }

    func testJobCompany() {
        let job = TestFixtures.Jobs.unorganised(account: account)
        setup(row: TestFixtures.Rows.standardRow(), job: job)

        XCTAssertEqual(tableViewCell?.jobSubtitle.text, job.company)
    }

    func testJobPublishedAt() {
        let testDate = Date(timeInterval: -1000, since: Date())
        let job = TestFixtures.Jobs.unorganised(account: account)
        job.pubDate = testDate

        setup(row: TestFixtures.Rows.standardRow(), job: job)

        XCTAssertEqual(tableViewCell?.jobDescription.text, "Published 16 minutes ago")
    }

    func testStateImageViewForUnreadJob() {
        let job = TestFixtures.Jobs.unorganised(account: account)

        setup(row: TestFixtures.Rows.standardRow(), job: job)

        let image = tableViewCell?.stateImageView.image
        let expectedImage = UIImage(named: "unread-indicator", in: Bundle.main, compatibleWith: nil)

        XCTAssertEqual(UIImagePNGRepresentation(image!), UIImagePNGRepresentation(expectedImage!))
    }

    func testStateImageViewForReadJob() {
        let job = TestFixtures.Jobs.read(account: account)

        setup(row: TestFixtures.Rows.standardRow(), job: job)

        let image = tableViewCell?.stateImageView.image
        let expectedImage = UIImage(named: "unread-indicator-blank", in: Bundle.main, compatibleWith: nil)

        XCTAssertEqual(UIImagePNGRepresentation(image!), UIImagePNGRepresentation(expectedImage!))
    }

    internal func setup(row: Row, job: Job? = nil) {
        let indexPath = IndexPath(row: 0, section: 0)
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

            tableViewCell = tableViewController.tableView(
                tableViewController.tableView, cellForRowAt: indexPath
            ) as? JobsTableViewCell

            _ = tableViewController.view
        }
    }
}
