import UIKit
import Log
import Bugsnag
import RealmSwift

let logger = Logger()
let realmProvider = RealmProvider.realm()

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        if Platform.isRunningTests() {
            let defaultsName = Bundle.main.bundleIdentifier!
            UserDefaults.standard.removePersistentDomain(forName: defaultsName)

            RealmProvider.deleteAll(realm: realmProvider)
        } else {
            if let key = environment.bugSnagKey {
                Bugsnag.start(withApiKey: key)
            }

            if Platform.isSimulator {
                logger.info("NSHomeDirectory", NSHomeDirectory())
            }
        }

        // Fetch data once an hour when app has not been terminated.
        UIApplication.shared.setMinimumBackgroundFetchInterval(3600)

        // Override point for customization after application launch.
        guard let splitViewController = window!.rootViewController as? UISplitViewController else {
            return false
        }

        splitViewController.preferredDisplayMode = .allVisible
        splitViewController.delegate = self

        return true
    }

    func application(_ application: UIApplication,
                     performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        let accounts = Account.activeSorted(provider: realmProvider)

        GetJobsService(accounts: accounts).call(completion: { _ in
            completionHandler(.newData)
        })
        completionHandler(.noData)
    }
}

extension AppDelegate: UISplitViewControllerDelegate {
    func splitViewController(_ splitViewController: UISplitViewController,
                             collapseSecondary secondaryViewController: UIViewController,
                             onto primaryViewController: UIViewController) -> Bool {
        guard let secondaryAsNavController = secondaryViewController as? UINavigationController else { return false }
        guard let topAsJobController = secondaryAsNavController.topViewController as? JobViewController else {
            return false
        }

        if topAsJobController.jobRecord == nil {
            // Return true to indicate that we have handled the collapse by doing nothing;
            // the secondary controller will be discarded.
            return true
        }
        return false
    }
}
