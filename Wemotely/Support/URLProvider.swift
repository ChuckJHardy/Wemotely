import Foundation

class URLProvider {
    var key: String
    var parentClass: AnyClass

    init(key: String, parentClass: AnyClass = URLProvider.self) {
        self.key = key
        self.parentClass = parentClass
    }

    func url() -> URL {
        if NSClassFromString("XCTest") != nil {
            return fileURL(key, type: "xml")
        } else {
            return URL(string: "https://weworkremotely.com/categories/\(key).rss")!
        }
    }

    private func fileURL(_ name: String, type: String) -> URL {
        let bundle = Bundle(for: parentClass)
        let filePath = bundle.path(forResource: name, ofType: type)
        return URL(fileURLWithPath: filePath!)
    }
}
