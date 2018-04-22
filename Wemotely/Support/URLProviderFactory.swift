import Foundation

protocol URLProviderProtocol {
    func url() -> URL
    func rss() -> URL
}

class BaseURLProvider {
    var key: String

    init(key: String) {
        self.key = key
    }

    static func baseUrl() -> URL {
        return URL(string: "https://weworkremotely.com")!
    }
}

class URLProviderFactory {
    var isTesting: Bool

    init(isTesting: Bool? = Platform.isRunningTests()) {
        self.isTesting = isTesting!
    }

    func build(key: String) -> URLProviderProtocol {
        if isTesting {
            return Testing(key: key)
        } else {
            return Running(key: key)
        }
    }

    class Testing: BaseURLProvider, URLProviderProtocol {
        static var testingHits: [String: String] = [:]

        func url() -> URL {
            Testing.testingHits[key] = testingFile()
            return FileLoader.load(name: Testing.testingHits[key]!, type: "xml")
        }

        func rss() -> URL {
            return url()
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
            return BaseURLProvider
                .baseUrl()
                .appendingPathComponent("categories")
                .appendingPathComponent(key)
        }

        func rss() -> URL {
            return url().appendingPathExtension("rss")
        }
    }
}
