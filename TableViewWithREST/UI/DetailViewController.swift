//
//  DetailViewController.swift
//  TableViewWithREST
//
//  Created by Michael Charland on 2019-08-23.
//  Copyright © 2019 charland. All rights reserved.
//

import BRYXBanner
import SafariServices
import UIKit

class DetailViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    var isStarred: Bool?
    var alertController: UIAlertController!
    var errorBanner: Banner?

    func configureView() {
        if let _ = self.gist {
            fetchStarredGists()
        }
        if let detailsView = self.tableView {
            detailsView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureView()
    }

    override func viewWillDisappear(_ animated: Bool) {
        if let existingBanner = self.errorBanner {
            existingBanner.dismiss()
        }
        super.viewWillDisappear(animated)
    }

    var gist: Gist? {
        didSet {
            // only reload if we changed gists
            if oldValue?.id != gist?.id {
                // Update the view.
                configureView()
            }
        }
    }
}

extension DetailViewController {
    func fetchStarredGists() {
        guard let gistId = gist?.id else {
            return
        }
        GitHubAPIManager.shared.isGistStarred(withID: gistId) { result in
            switch result {
            case let .success(status):
                if self.isStarred == nil {
                    self.isStarred = status
                    self.tableView.insertRows(at: [IndexPath(row: 2, section: 0)], with: .automatic)
                }
            case let .failure(error):
                switch error {
                case BackendError.authLost:
                    self.alertController = UIAlertController(
                        title: "Auth Lost",
                        message: error.localizedDescription,
                        preferredStyle: .alert)
                    let ok = UIAlertAction(title: "ok", style: .default, handler: nil)
                    self.alertController.addAction(ok)
                    self.present(self.alertController, animated: true, completion: nil)
                case let BackendError.network(innerError as NSError):
                    if innerError.domain != NSURLErrorDomain {
                        return
                    }
                    if innerError.code == NSURLErrorNotConnectedToInternet {
                        self.showNotConnectedErrorBanner(title: "No internet", message: "Can't star")
                    }
                default:
                    return
                }
            }
        }
    }

    func showNotConnectedErrorBanner(title: String, message: String) {
        errorBanner = Banner(title: title, subtitle: message, image: nil, backgroundColor: .orange, didTapBlock: nil)
        self.errorBanner?.dismissesOnSwipe
        self.errorBanner?.show(nil, duration: nil)
    }

    func starThisGist() {
        guard let gistID = gist?.id else {
            return
        }
        GitHubAPIManager.shared.starGist(withID: gistID) { (result) in
            switch result {
            case .success:
                self.isStarred = true
            case let .failure(error):
                self.isStarred = nil
                let errorMessage: String?
                switch error {
                case BackendError.authLost:
                    errorMessage = error.localizedDescription
                default:
                    errorMessage = """
                    Sorry, your gist couldn't be starred,
                    Maybe GitHub is down or you don't have an internet connection
                    """
                    break
                }
                if let errorMessage = errorMessage {
                    self.alertController = UIAlertController(title: "Could not star gist", message: errorMessage, preferredStyle: .alert)
                    let ok = UIAlertAction(title: "ok", style: .default, handler: nil)
                    self.alertController.addAction(ok)
                    self.present(self.alertController, animated: true, completion: nil)
                }
            }
        }
        tableView.reloadRows(at: [IndexPath(row: 2, section: 0)], with: .automatic)
    }

    func unstarThisGist() {
        guard let gistID = gist?.id else {
            return
        }
        GitHubAPIManager.shared.unstarGist(withID: gistID) { (result) in
            switch result {
            case .success:
                self.isStarred = false
            case let .failure(error):
                self.isStarred = nil
                let errorMessage: String?
                switch error {
                case BackendError.authLost:
                    errorMessage = error.localizedDescription
                default:
                    errorMessage = """
                    Sorry, your gist couldn't be unstarred,
                    Maybe GitHub is down or you don't have an internet connection
                    """
                    break
                }
                if let errorMessage = errorMessage {
                    self.alertController = UIAlertController(title: "Could not star gist", message: errorMessage, preferredStyle: .alert)
                    let ok = UIAlertAction(title: "ok", style: .default, handler: nil)
                    self.alertController.addAction(ok)
                    self.present(self.alertController, animated: true, completion: nil)
                }
            }
        }
        tableView.reloadRows(at: [IndexPath(row: 2, section: 0)], with: .automatic)
    }
}

extension DetailViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if let _ = isStarred {
                return 3
            }
            return 2
        } else {
            return gist?.files.count ?? 0
        }
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "About"
        } else {
            return "Files"
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")

        switch (indexPath.section, indexPath.row, isStarred) {
        case (0, 0, _):
            if gist?.gistDescription?.isEmpty ?? true {
                cell?.textLabel?.text = "<< No Description >>"
            } else {
                cell?.textLabel?.text = gist?.gistDescription
            }

        case (0, 1, _):
            cell?.textLabel?.text = gist?.owner?.login
        case (0, 2, .none):
            cell?.textLabel?.text = ""
        case (0, 2, .some(true)):
            cell?.textLabel?.text = "Unstar"
        case (0, 2, .some(false)):
            cell?.textLabel?.text = "Star"
        default:
            let file = gist?.orderedFiles[indexPath.row]
            cell?.textLabel?.text = file?.name
        }
        return cell!
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        switch (indexPath.section, indexPath.row, isStarred) {
        case (0, 2, .some(true)):
            unstarThisGist()
        case (0, 2, .some(false)):
            starThisGist()
        case (1, _, _):
            guard let file = gist?.orderedFiles[indexPath.row],
                let url = file.details.url else {
                return
            }

            let safariViewController = SFSafariViewController(url: url)
            safariViewController.title = file.name
            self.navigationController?.pushViewController(safariViewController, animated: true)
        default:
            break
        }
    }
}

