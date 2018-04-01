import Foundation

class URLProvider {
    var key: String

    init(key: String) {
        self.key = key
    }

    func url(isTesting: Bool = Platform.isRunningTests()) -> URL {
        if isTesting {
            return FileLoader.load(name: "jobs", type: "xml")
        } else {
            return URL(string: "https://weworkremotely.com/categories/\(key).rss")!
        }
    }
}
