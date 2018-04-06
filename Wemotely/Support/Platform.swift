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

    static func delayBackgroundProcessBy(override: UInt32 = 0) {
        var delay = override

        if let index = CommandLine.arguments.index(of: "--uitesting-set-delay") {
            let value = CommandLine.arguments[index + 1]
            delay = UInt32(value)!
        }

        sleep(delay)
    }
}
