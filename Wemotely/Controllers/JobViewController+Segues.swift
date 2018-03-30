import Foundation

extension JobViewController {
    func setupSegue(job: Job) {
        jobRecord = job

        if let split = splitViewController {
            navigationItem.leftItemsSupplementBackButton = true
            navigationItem.leftBarButtonItem = split.displayModeButtonItem
        }

        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.largeTitleDisplayMode = .never
    }
}
