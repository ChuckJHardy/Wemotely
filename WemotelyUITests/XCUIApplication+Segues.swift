import XCTest

extension XCUIApplication {
    var isDisplayingDashboard: Bool {
        return tables["dashboardTableView"].exists
    }
    
    var isDisplayingFilter: Bool {
        return tables["filterTableView"].exists
    }
}
