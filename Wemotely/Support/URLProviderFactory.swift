import Foundation

protocol URLProviderProtocol {
    func url() -> URL
}

class BaseURLProvider {
    var key: String

    init(key: String) {
        self.key = key
    }
}

class URLProviderFactory {
    var isTesting: Bool

    init(isTesting: Bool? = Platform.isRunningTests()) {
        self.isTesting = isTesting!
    }

    func build(key: String) -> URL {
        if isTesting {
            return Testing(key: key).url()
        } else {
            return Running(key: key).url()
        }
    }

    class Testing: BaseURLProvider, URLProviderProtocol {
        static var testingHits: [String: String] = [:]

        func url() -> URL {
            Testing.testingHits[key] = testingFile()
            return FileLoader.load(name: Testing.testingHits[key]!, type: "xml")
        }

        private func testingFile() -> String {
            if Testing.testingHits[key] == nil {
                return "jobs"
            } else {
                return "jobs-other"
            }
        }
    }

    class Running: BaseURLProvider, URLProviderProtocol {
        func url() -> URL {
            return URL(string: "https://weworkremotely.com/categories/\(key).rss")!
        }
    }
}
