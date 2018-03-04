import XCTest

extension XCUIApplication {
    var supportedOrientations: [UIDeviceOrientation] {
        return [
            UIDeviceOrientation.portrait,
            UIDeviceOrientation.landscapeLeft
        ]
    }
    
    func isPad() -> Bool {
        return UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad
    }
    
    func isPhone() -> Bool {
        return UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone
    }
    
    func resetOrientation() {
        XCUIDevice.shared.orientation = .portrait
    }
    
    func runWithSupportedOrientations(block: () -> Void) {
        for orientation in supportedOrientations {
            XCUIDevice.shared.orientation = orientation
            block()
        }
    }
}
