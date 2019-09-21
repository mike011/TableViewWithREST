//
//  MasterViewController.swift
//  TableViewWithREST
//
//  Created by Michael Charland on 2019-08-23.
//  Copyright © 2019 charland. All rights reserved.
//

import PINRemoteImage
import SafariServices
import UIKit

class MasterViewController: UITableViewController, SFSafariViewControllerDelegate {

    // MARK: - Outlets
    @IBOutlet var gistSegmentedControl: UISegmentedControl!

    // MARK: - App
    var detailViewController: DetailViewController?
    var safariViewController: SFSafariViewController?
    var gists: [Gist] = []
    var nextPageURLString: String?
    var isLoading = false
    var dateFormatter = DateFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
        navigationItem.rightBarButtonItem = addButton
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // add refresh control for pull to refresh
        if (self.refreshControl == nil) {
            self.refreshControl = UIRefreshControl()
            self.refreshControl?.addTarget(
                self,
                action: #selector(refresh(sender:)),
                for: .valueChanged
            )
        }

        loadGists(urlToLoad: nil)

        // TEST
        //GitHubAPIManager.shared.printMyStarredGistsWithBasicAuth()
        //DarkSkyAPIManager.shared.getForecast(location: "51.50998,-0.1337")
        //GitHubAPIManager.shared.printMashapeRouterRequest()
//        if (GitHubAPIManager.shared.hasOAuthToken()) {
//            GitHubAPIManager.shared.mergePullRequest()
//        }
       // CircleCIAPIManager.shared.printProjects()
//        CircleCIAPIManager.shared.printSingleJob()
        // END TEST

        self.dateFormatter.dateStyle = .short
        self.dateFormatter.timeStyle = .long

        if (!GitHubAPIManager.shared.isLoadingOAuthToken) {
            loadInitialData()
        }
    }

    func loadInitialData() {
        isLoading = true
        GitHubAPIManager.shared.OAuthTokenCompletionHandler = { error in
            guard error == nil else {
                print(error!)
                self.isLoading = false
                // TODO: handle error
                // Something went wrong, try again
                self.showOAuthLoginView()
                return
            }
            if let _ = self.safariViewController {
                self.dismiss(animated: false) {}
            }
            self.loadGists(urlToLoad: nil)
        }

        StravaAPIManager.shared.OAuthTokenCompletionHandler = { error in
            guard error == nil else {
                print(error!)
                self.isLoading = false
                // TODO: handle error
                // Something went wrong, try again
                self.showOAuthLoginView()
                return
            }
            if let _ = self.safariViewController {
                self.dismiss(animated: false) {}
            }
            self.printActivities()
        }

        if (!GitHubAPIManager.shared.hasOAuthToken()) {
            showOAuthLoginView()
            return
        }
        loadGists(urlToLoad: nil)
    }

    func showOAuthLoginView() {
        GitHubAPIManager.shared.isLoadingOAuthToken = true
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let loginVC = storyboard.instantiateViewController(
            withIdentifier: "LoginViewController") as? LoginViewController else {
                assert(false, "Misnamed view controller")
                return
        }
        loginVC.delegate = self
        self.present(loginVC, animated: true, completion: nil)
    }

    @objc func refresh(sender: Any) {
        GitHubAPIManager.shared.isLoadingOAuthToken = false
        nextPageURLString = nil // so it doesn't try to append the results
        GitHubAPIManager.shared.clearCache()
        loadInitialData()
    }

    func printActivities() {
        StravaAPIManager.shared.getActivities { (result, error) in
            switch result {
            case let .success(exercises):
                exercises.first?.printColumns()
                for exercise in exercises.reversed() {
                    if exercise.commute {
                        exercise.printCommute()
                    }
                }
                print("Commutes Printed")
            case let .failure(error):
                print("Error!! \(error.localizedDescription)")
            }
        }
    }

    func loadGists(urlToLoad: String?) {
        self.isLoading = true

        switch gistSegmentedControl.selectedSegmentIndex {
        case 0:
            GitHubAPIManager.shared.fetchPublicGists(
                pageToLoad: urlToLoad,
                completionHandler: getCompletionHandler(urlToLoad: urlToLoad)
            )
        case 1:
            GitHubAPIManager.shared.fetchMyStarredGists(
                pageToLoad: urlToLoad,
                completionHandler: getCompletionHandler(urlToLoad: urlToLoad)
            )
        case 2:
            GitHubAPIManager.shared.fetchMyGists(
                pageToLoad: urlToLoad,
                completionHandler: getCompletionHandler(urlToLoad: urlToLoad)
            )
        default:
            print("got an index that I didn't expect for selectedSegmentIndex")
        }
    }

    func getCompletionHandler(urlToLoad: String?) -> (Result<[Gist], Error>, String?) -> Void {
        let completionHandler: (Result<[Gist], Error>, String?) -> Void = {
            (result, nextPage) in
            self.isLoading = false
            self.nextPageURLString = nextPage

            // tell refresh control it can stop showing up now
            if let refreshControl = self.refreshControl,
                refreshControl.isRefreshing {
                refreshControl.endRefreshing()
            }

            // update "last updated" title for refresh control
            let now = Date()
            let updateString = "Last Updated at " + self.dateFormatter.string(from: now)
            self.refreshControl?.attributedTitle = NSAttributedString(string: updateString)

            switch result {
            case .success(let data):
                if urlToLoad == nil {
                    // empty out the gists because we're not loading another page
                    self.gists = []
                }
                self.gists += data
            case .failure(let error):
                self.handleLoadGistsError(error)
            }
            self.tableView.reloadData()
        }
        return completionHandler
    }

    func handleLoadGistsError(_ error: Error) {
        nextPageURLString = nil
        isLoading = false
        switch error {
        case BackendError.authLost:
            self.showOAuthLoginView()
            return
        default:
            break
        }
    }

    @objc
    func insertNewObject(_ sender: Any) {
        let alert = UIAlertController(
                title: "Not Implemented",
                message: "Can't create new gists yet, will implement later",
                preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(
            title: "OK",
            style: .default,
            handler: nil)
        )
        self.present(alert, animated: true, completion: nil)
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let gist = gists[indexPath.row]
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.gist = gist
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gists.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let gist = gists[indexPath.row]
        cell.textLabel?.text = gist.gistDescription
        cell.detailTextLabel?.text = gist.owner?.login

        if !isLoading {
            let rowsLoaded = gists.count
            let rowsRemaining = rowsLoaded - indexPath.row
            let rowsToLoadFromBottom = 5
            if rowsRemaining <= rowsToLoadFromBottom {
                if let nextPage = nextPageURLString {
                    self.loadGists(urlToLoad: nextPage)
                }
            }
        }

        cell.imageView?.image = nil
        if let url = gist.owner?.avatarURL {
            GitHubAPIManager.shared.imageFrom(url: url) { (image, error) in
                guard error == nil else {
                    print(error!)
                    return
                }

                // set cell.imageView to display image at gist.owner?.avatarURL
                let placeholder = UIImage(named: "placeholder")
                cell.imageView?.image = placeholder
                if let url = gist.owner?.avatarURL {
                    cell.imageView?.pin_setImage(from: url, placeholderImage:
                    placeholder) {
                        result in
                        if let cellToUpdate = self.tableView?.cellForRow(at: indexPath) {
                            cellToUpdate.setNeedsLayout()
                        }
                    }
                } 
                cell.setNeedsLayout()
            }
        }

        // TODO: set cell.imageView to display image at gist.ownerAvatarURL
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
         return gistSegmentedControl.selectedSegmentIndex == 2
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let gistToDelete = gists[indexPath.row]

            // remove from a rray of gists
            gists.remove(at: indexPath.row)

            // remove from tableview
            tableView.deleteRows(at: [indexPath], with: .fade)

            // delete from api
            GitHubAPIManager.shared.deleteGist(withID: gistToDelete.id) { (result) in
                switch result {
                case .success:
                    break
                case let .failure(error):
                    print(error)

                    // Put it back
                    self.gists.insert(gistToDelete, at: indexPath.row)
                    tableView.insertRows(at: [indexPath], with: .right)

                    // Tell them it didn't work
                    let alertController = UIAlertController(title: "Could not delete gist", message: "Sorry, your gist couldn't be deleted", preferredStyle: .alert)
                    let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertController.addAction(okButton)

                    // show the alert
                    self.present(alertController, animated: true, completion: nil)

                }
            }
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }

    // MARK: - Safari View Controller Delegate
    func safariViewController(
        _ controller: SFSafariViewController,
        didCompleteInitialLoad didLoadSuccessfully: Bool) {
        
        // Detect not being able to load the OAuth URL
        if (!didLoadSuccessfully) {
            controller.dismiss(animated: true, completion: nil)
        }
    }
}

extension MasterViewController: LoginViewDelegate {

    func didTapLoginButton() {
        self.dismiss(animated: false) {
            guard let authURL = GitHubAPIManager.shared.URLToStartOAuth2Login() else {
                let error = BackendError.authCouldNot(reason: "Could not obtain an OAuth token")
                GitHubAPIManager.shared.OAuthTokenCompletionHandler?(error)
                return
            }
            // Show web page to start OAuth
            self.safariViewController = SFSafariViewController(url: authURL)
            self.safariViewController?.delegate = self
            guard let webViewController = self.safariViewController else {
                return
            }
            self.present(webViewController, animated: true, completion: nil)
        }
    }
}

extension MasterViewController {
    func didTapAuthenticateButton() {
        self.dismiss(animated: false) {
            guard !StravaAPIManager.shared.hasOAuthToken() else {
                self.printActivities()
                return
            }
            guard let authURL = StravaAPIManager.shared.URLToStartOAuth2Login() else {
                let error = BackendError.authCouldNot(reason: "Could not obtain an OAuth token")
                StravaAPIManager.shared.OAuthTokenCompletionHandler?(error)
                return
            }
            // Show web page to start oauth
            self.safariViewController = SFSafariViewController(url: authURL)
            self.safariViewController?.delegate = self
            guard let webViewController = self.safariViewController else {
                return
            }
            self.present(webViewController, animated: true, completion: nil)
        }
    }
}

// MARK: - Actions

extension MasterViewController {

    @IBAction func segmentedControlValueChanged(sender: UISegmentedControl) {
        gists = []
        tableView.reloadData()

        // Only show button for my gists
        if (gistSegmentedControl.selectedSegmentIndex == 2) {
            self.navigationItem.leftBarButtonItem = self.editButtonItem
        } else {
            self.navigationItem.leftBarButtonItem = nil
        }

        loadGists(urlToLoad: nil)
    }
}
