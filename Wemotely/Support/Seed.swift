import Foundation
import RealmSwift

class Seed: NSObject {
    var realm: Realm
    var app: App!

    init(realm: Realm) {
        self.realm = realm
    }

    enum Categories: String {
        case programming = "Programming"
        case customerSupport = "Customer Support"
        case devops = "Devops"
        case marketing = "Marketing"
        case business = "Business/Management"
        case copywriting = "Copywriting"
    }

    func call() {
        if let existingApp = realm.objects(App.self).first {
            app = existingApp
        } else {
            app = App()
        }

        if !app.seeded {
            for account in accounts() {
                app.accounts.append(account)
            }

            app.seeded = true

            do {
                try realm.write {
                    realm.add(app, update: true)
                }
            } catch let err {
                logger.error("Application failed to save", err)
            }
        }
    }

    // swiftlint:disable:next function_body_length
    func accounts() -> [Account] {
        return [
            Account(
                value: [
                    "title": Categories.programming.rawValue,
                    "icon": "inbox",
                    "unreadCount": 0,
                    "active": true,
                    "urlKey": "remote-programming-jobs",
                    "order": 0
                ]
            ),
            Account(
                value: [
                    "title": Categories.customerSupport.rawValue,
                    "icon": "inbox",
                    "unreadCount": 0,
                    "active": true,
                    "urlKey": "remote-customer-support-jobs",
                    "order": 1
                ]
            ),
            Account(
                value: [
                    "title": Categories.devops.rawValue,
                    "icon": "inbox",
                    "unreadCount": 0,
                    "active": true,
                    "urlKey": "remote-devops-sysadmin-jobs",
                    "order": 2
                ]
            ),
            Account(
                value: [
                    "title": Categories.marketing.rawValue,
                    "icon": "inbox",
                    "unreadCount": 0,
                    "active": true,
                    "urlKey": "remote-marketing-jobs",
                    "order": 3
                ]
            ),
            Account(
                value: [
                    "title": Categories.business.rawValue,
                    "icon": "inbox",
                    "unreadCount": 0,
                    "active": true,
                    "urlKey": "remote-business-exec-management-jobs",
                    "order": 4
                ]
            ),
            Account(
                value: [
                    "title": Categories.copywriting.rawValue,
                    "icon": "inbox",
                    "unreadCount": 0,
                    "active": true,
                    "urlKey": "remote-copywriting-jobs",
                    "order": 5
                ]
            )
        ]
    }
}
