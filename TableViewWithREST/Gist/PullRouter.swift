//
//  PullRouter.swift
//  TableViewWithREST
//
//  Created by Michael Charland on 2019-08-23.
//  Copyright © 2019 charland. All rights reserved.
//

import Alamofire
import Foundation

enum PullRouter: URLRequestConvertible {
    static let baseURLString = "https://api.github.com/"

    case pull(owner: String, repo: String, number: Int)
    case pulls(owner: String, repo: String)
    case merge(owner: String, repo: String, number: Int)

    func asURLRequest() throws -> URLRequest {
        var method: HTTPMethod {
            switch self {
            case .merge:
                return .put
            case .pull:
                return .get
            case .pulls:
                return .get

            }
        }

        let url: URL = {
            switch self {
            case let .merge(owner, repo, number):
                let relativePath = "repos/\(owner))/\(repo)/pulls/\(number)/merge"
                var url = URL(string: PullRouter.baseURLString)!
                url.appendPathComponent(relativePath)
                return url
            case let .pull(owner, repo, number):
                // GET /repos/:owner/:repo/pulls
                let relativePath = "repos/\(owner))/\(repo)/pulls/\(number)"
                var url = URL(string: PullRouter.baseURLString)!
                url.appendPathComponent(relativePath)
                return url
            case let .pulls(owner, repo):
                // GET /repos/:owner/:repo/pulls
                let relativePath = "repos/\(owner))/\(repo)/pulls"
                var url = URL(string: PullRouter.baseURLString)!
                url.appendPathComponent(relativePath)
                return url
            }
        }()

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue

        // Set OAuth token if we have one
        if let token = GitHubAPIManager.shared.oAuthToken {
            urlRequest.setValue("token \(token)", forHTTPHeaderField: "Authorization")
        }

        return urlRequest
    }
}

