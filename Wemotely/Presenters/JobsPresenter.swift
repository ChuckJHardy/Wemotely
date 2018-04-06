import Foundation

class JobsPresenter: NSObject {
    func pullToRefreshMessage(date: Date? = nil) -> String {
        var message = "Pull to refresh"

        if let date = date {
            message = "Last updated \(formatDate(date: date))"
        }

        return message
    }

    private func formatDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        dateFormatter.locale = Locale(identifier: "en_US")
        return dateFormatter.string(from: date)
    }
}
