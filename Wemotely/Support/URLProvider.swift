import Foundation

class URLProvider {
    var key: String

    init(key: String) {
        self.key = key
    }

    func url(isTesting: Bool = Platform.isRunningTests()) -> URL {
        if isTesting {
            return fileURL("jobs", type: "xml")
        } else {
            return URL(string: "https://weworkremotely.com/categories/\(key).rss")!
        }
    }

    private func fileURL(_ name: String, type: String) -> URL {
        let bundle = Bundle.main
        let filePath = bundle.path(forResource: name, ofType: type)
        return URL(fileURLWithPath: filePath!)
    }
}
