import Foundation

class JobsPresenter: BasePresenter {
    func navigationPrompt(date: Date? = nil) -> String {
        return dateAsString(prefix: "Updated", date: date)
    }
}
