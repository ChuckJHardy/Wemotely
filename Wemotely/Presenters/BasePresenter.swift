import Foundation

class BasePresenter {
    var locale: Locale!

    init(locale: Locale? = Locale.current) {
        self.locale = locale
    }

    func dateAsString(prefix: String, date: Date? = nil) -> String {
        if let validDate = date, let formattedDate = formatDate(date: validDate) {
            return "\(prefix) \(formattedDate.timeAgo())"
        }

        return ""
    }

    private func formatDate(date: Date) -> Date? {
        let component = Calendar.current.dateComponents(in: TimeZone.current, from: date)
        return component.date
    }
}
