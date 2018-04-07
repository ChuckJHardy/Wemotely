import Foundation

// https://gist.github.com/minorbug/468790060810e0d29545#gistcomment-2272953
extension Date {
    fileprivate struct Item {
        let multi: String
        let single: String
        let last: String
        let value: Int?
    }

    fileprivate var components: DateComponents {
        return Calendar.current.dateComponents(
            [.minute, .hour, .day, .weekOfYear, .month, .year, .second],
            from: Calendar.current.date(byAdding: .second, value: 1, to: Date())!,
            to: self
        )
    }

    fileprivate var items: [Item] {
        return [
            Item(multi: "years ago", single: "1 year ago", last: "last year", value: components.year),
            Item(multi: "months ago", single: "1 month ago", last: "last month", value: components.month),
            Item(multi: "weeks ago", single: "1 week ago", last: "last week", value: components.weekday),
            Item(multi: "days ago", single: "1 day ago", last: "last day", value: components.day),
            Item(multi: "minutes ago", single: "1 minute ago", last: "last minute", value: components.minute),
            Item(multi: "seconds ago", single: "just now", last: "last second", value: components.second)
        ]
    }

    public func timeAgo(numericDates: Bool = false) -> String {
        for item in items {
            switch (item.value, numericDates) {
            case let (.some(step), _) where abs(step) == 0:
                continue
            case let (.some(step), true) where abs(step) == 1:
                return item.last
            case let (.some(step), false) where abs(step) == 1:
                return item.single
            case let (.some(step), _):
                return String(abs(step)) + " " + item.multi
            default:
                continue
            }
        }

        return "just now"
    }
}
