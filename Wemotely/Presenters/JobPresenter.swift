import Foundation

class JobPresenter: BasePresenter {
    func publishedAt(date: Date? = nil) -> String {
        return dateAsString(prefix: "Published", date: date)
    }
}
