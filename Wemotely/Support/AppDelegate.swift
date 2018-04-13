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

        // Fetch data once every 12 hours when app has not been terminated.
        UIApplication.shared.setMinimumBackgroundFetchInterval(43200)

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
        guard let splitViewController = window!.rootViewController as? UISplitViewController else {
            completionHandler(.failed)
            return
        }

        for viewController in splitViewController.viewControllers {
            guard let navController = viewController as? UINavigationController else {
                continue
            }

            if let controller = navController.topViewController as? DashboardTableViewController {
                let accounts = Account.activeSorted(provider: realmProvider)

                Seed(provider: realmProvider).call(before: {}, after: {}, skipped: {
                    GetJobsService(accounts: accounts).call(completion: { _ in
                        controller.handleDataUpdate()
                        completionHandler(.newData)
                    })
                })
            }
        }

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
