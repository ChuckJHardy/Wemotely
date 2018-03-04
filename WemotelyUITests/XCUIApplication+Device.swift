import XCTest

extension XCUIApplication {
    var supportedOrientations: [UIDeviceOrientation] {
        return [
            UIDeviceOrientation.portrait,
            UIDeviceOrientation.landscapeLeft
        ]
    }
    
    func resetOrientation() {
        XCUIDevice.shared.orientation = .portrait
    }
}
