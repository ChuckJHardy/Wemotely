import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    static var accounts: [Account] = [
        Account(
            value: [
                "title": "Inbox",
                "jobs": [
                    Job(value: ["title": "Engineer 1"]),
                    Job(value: ["title": "Manager 1"]),
                    Job(value: ["title": "Astronaut 1"])
                ]
            ]
        ),
        Account(
            value: [
                "title": "Favourites",
                "jobs": [
                    Job(value: ["title": "Engineer 2"])
                ]
            ]
        ),
        Account(
            value: [
                "title": "Trash",
                "jobs": [
                    Job(value: ["title": "Manager 2"])
                ]
            ]
        )
    ]

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        if CommandLine.arguments.contains("--uitesting") {
            let defaultsName = Bundle.main.bundleIdentifier!
            UserDefaults.standard.removePersistentDomain(forName: defaultsName)
            // Clear Database
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
