import Foundation

class FileLoader {
    static func load(name: String, type: String) -> URL {
        let bundle = Bundle.main
        let filePath = bundle.path(forResource: name, ofType: type)
        return URL(fileURLWithPath: filePath!)
    }
}
