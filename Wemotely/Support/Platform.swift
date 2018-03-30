import UIKit

// http://themainthread.com/blog/2015/06/simulator-check-in-swift.html
struct Platform {
    static let isSimulator: Bool = {
        var isSim = false
        #if targetEnvironment(simulator)
            isSim = true
        #endif
        return isSim
    }()

    static func isRunningTests() -> Bool {
        return CommandLine.arguments.contains("--uitesting") || (NSClassFromString("XCTest") != nil)
    }
}
