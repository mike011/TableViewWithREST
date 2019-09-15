//
//  GitHubAPIManager+Pull.swift
//  TableViewWithREST
//
//  Created by Michael Charland on 2019-09-08.
//  Copyright © 2019 charland. All rights reserved.
//

import Alamofire
import Foundation

extension GitHubAPIManager {

    // MARK: - Basic Auth
    func printPullRequests() {
        AF.request(PullRouter.pulls(owner: "mike011", repo: "TapMe"))
            .responseJSON { response in
                switch response.result {
                case .success(let data):
                    print("here")
                    print(data)
                case .failure(let failure):
                    print(failure)
                }
        }
    }

    func mergePullRequest() {
        AF.request(PullRouter.merge(owner: "mike011", repo: "TapMe", number: 5))
            .responseJSON { response in

            switch response.result {
            case .success(let data):
                print(data)
            case .failure(let failure):
                print(failure)
            }
        }
    }
}
