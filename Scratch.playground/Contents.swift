//: Playground - noun: a place where people can play

import UIKit

// Find account with oldest date

struct Account {
    var expectedPosition: Int!
    var date: Date!
}

let date1 = Date(timeInterval: -1000, since: Date())
let date2 = Date(timeInterval: -2000, since: Date())
let date3 = Date(timeInterval: -3000, since: Date())

let accounts = [
    Account(expectedPosition: 1, date: date3),
    Account(expectedPosition: 3, date: date1),
    Account(expectedPosition: 2, date: date2)
]

let sortedAccounts = accounts.sorted { (account, other) -> Bool in
    account.date < other.date
}

print(sortedAccounts)

sortedAccounts.first?.date
