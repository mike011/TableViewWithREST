//
//  DetailViewController.swift
//  TableViewWithREST
//
//  Created by Michael Charland on 2019-08-23.
//  Copyright © 2019 charland. All rights reserved.
//

import SafariServices
import UIKit

class DetailViewController: UIViewController {

    @IBOutlet var tableView: UITableView!

    func configureView() {
        if let detailsView = self.tableView {
            detailsView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureView()
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

extension DetailViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
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

        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            if gist?.gistDescription?.isEmpty ?? true {
                cell?.textLabel?.text = "<< No Description >>"
            } else {
                cell?.textLabel?.text = gist?.gistDescription
            }

        case (0, 1):
            cell?.textLabel?.text = gist?.owner?.login
        default:
            let file = gist?.orderedFiles[indexPath.row]
            cell?.textLabel?.text = file?.name
        }
        return cell!
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if indexPath.section == 1 {
            guard let file = gist?.orderedFiles[indexPath.row] else {
                return
            }
            let url = file.details.url
            let safariViewController = SFSafariViewController(url: url)
            safariViewController.title = file.name
            self.navigationController?.pushViewController(safariViewController, animated: true)
        }
    }
}

