import Foundation

extension JobViewController {
    func setupSegue(job: Job) {
        jobRecord = job

        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.largeTitleDisplayMode = .never

        if let job = jobRecord {
            title = job.company
            navigationItem.prompt = job.title
        }
    }
}
