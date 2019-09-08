//
//  DetailViewController.swift
//  TableViewWithREST
//
//  Created by Michael Charland on 2019-08-23.
//  Copyright © 2019 charland. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!


    func configureView() {
        // Update the user interface for the detail item.
        if let detail = detailItem {
            if let label = detailDescriptionLabel {
                label.text = detail.gistDescription
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureView()
    }

    var detailItem: Gist? {
        didSet {
            // Update the view.
            configureView()
        }
    }


}

