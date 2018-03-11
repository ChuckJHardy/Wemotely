import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    let realm = RealmProvider.realm()

    var window: UIWindow?

    static func isRunningTests() -> Bool {
        return CommandLine.arguments.contains("--uitesting") || (NSClassFromString("XCTest") != nil)
    }

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        if AppDelegate.isRunningTests() {
            let defaultsName = Bundle.main.bundleIdentifier!
            UserDefaults.standard.removePersistentDomain(forName: defaultsName)
            RealmProvider.deleteAll(realm: realm)
        }

        // Override point for customization after application launch.
        let splitViewController = window!.rootViewController as! UISplitViewController
        splitViewController.preferredDisplayMode = .allVisible
        splitViewController.delegate = self
        return true
    }
}

extension AppDelegate: UISplitViewControllerDelegate {
    func splitViewController(_ splitViewController: UISplitViewController,
                             collapseSecondary secondaryViewController: UIViewController,
                             onto primaryViewController: UIViewController) -> Bool {
        guard let secondaryAsNavController = secondaryViewController as? UINavigationController else { return false }
        guard let topAsJobController = secondaryAsNavController.topViewController as? JobViewController else { return false }
        if topAsJobController.jobRecord == nil {
            // Return true to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
            return true
        }
        return false
    }
}
