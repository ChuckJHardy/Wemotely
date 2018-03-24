// http://themainthread.com/blog/2015/06/simulator-check-in-swift.html
struct Platform {
    static let isSimulator: Bool = {
        var isSim = false
        #if (arch(i386) || arch(x86_64)) && (os(iOS) || os(watchOS) || os(tvOS))
            isSim = true
        #endif
        return isSim
    }()
}
