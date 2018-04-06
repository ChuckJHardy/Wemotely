import XCTest

extension XCUIApplication {
    var isDisplayingDashboard: Bool {
        return tables["dashboardTableView"].isHittable
    }

    var isDisplayingEditDashboard: Bool {
        return tables["editDashboardTableView"].exists
    }

    var isDisplayingSettings: Bool {
        return tables["settingsTableView"].exists
    }

    var isDisplayingJob: Bool {
        return otherElements["jobTableView"].exists
    }

    var isDisplayingJobs: Bool {
        return tables["jobsTableView"].exists
    }

    var isDisplayingFavourites: Bool {
        return self.navigationBars["Favourites"].exists
    }

    var isDisplayingTrash: Bool {
        return self.navigationBars["Trash"].exists
    }

    func startAndEndOnDashboard(block: () -> Void) {
        XCTAssertTrue(isDisplayingDashboard, "Failed to start on Dashboard Screen")
        block()
        XCTAssertTrue(isDisplayingDashboard, "Failed to Segue back to 'Dashboard' Screen")
    }
}
