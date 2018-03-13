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
}
