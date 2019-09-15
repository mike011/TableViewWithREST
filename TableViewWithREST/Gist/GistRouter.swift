//
//  GistRouter.swift
//  TableViewWithREST
//
//  Created by Michael Charland on 2019-08-23.
//  Copyright © 2019 charland. All rights reserved.
//

import Alamofire
import Foundation

enum GistRouter: URLRequestConvertible {
    static let baseURLString = "https://api.github.com/"

    case getAtPath(_ urlString: String)
    case getMyGists
    case getMyStarred
    case getPublic

    func asURLRequest() throws -> URLRequest {
        var method: HTTPMethod {
            switch self {
            case .getAtPath:
                return .get
            case .getMyGists:
                return .get
            case .getMyStarred:
                return .get
            case .getPublic:
                return .get
            }
        }

        let url: URL = {
            switch self {
            case let .getAtPath(urlString):
                // already have the full URL, so just return it
                return URL(string: urlString)!
            case .getMyGists:
                let relativePath = "gists"
                var url = URL(string: GistRouter.baseURLString)!
                url.appendPathComponent(relativePath)
                return url
            case .getMyStarred:
                let relativePath = "gists/starred"
                var url = URL(string: GistRouter.baseURLString)!
                url.appendPathComponent(relativePath)
                return url
            case .getPublic:
                let relativePath = "gists/public"
                var url = URL(string: GistRouter.baseURLString)!
                url.appendPathComponent(relativePath)
                return url
            }
        }()

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue

        // Set OAuth token if we have one
        if let token = GitHubAPIManager.shared.OAuthToken {
            urlRequest.setValue("token \(token)", forHTTPHeaderField: "Authorization")
        }

        return urlRequest
    }
}

