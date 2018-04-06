import Foundation

class JobsPresenter: NSObject {
    var locale: Locale!

    init(locale: Locale? = Locale.current) {
        self.locale = locale
    }

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
        dateFormatter.locale = locale
        return dateFormatter.string(from: date)
    }
}
