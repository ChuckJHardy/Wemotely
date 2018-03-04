import XCTest

extension XCUIApplication {
    var isDisplayingDashboard: Bool {
        return tables["dashboardTableView"].exists
    }
    
    var isDisplayingFilter: Bool {
        return tables["filterTableView"].exists
    }
    
    var isDisplayingSettings: Bool {
        return tables["settingsTableView"].exists
    }
    
    var isDisplayingJobs: Bool {
        return tables["jobsTableView"].exists
    }
}
