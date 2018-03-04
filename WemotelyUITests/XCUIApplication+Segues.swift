import XCTest

extension XCUIApplication {
    var isDisplayingDashboard: Bool {
        return tables["dashboardTableView"].isHittable
    }
    
    var isDisplayingFilter: Bool {
        return tables["filterTableView"].exists
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
