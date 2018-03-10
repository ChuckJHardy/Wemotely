import Foundation

class URLProvider {
    var key: String

    init(key: String) {
        self.key = key
    }

    func url() -> URL {
        if AppDelegate.isRunningTests() {
            return fileURL(key, type: "xml")
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
