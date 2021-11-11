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

    case create(Data)
    case delete(id: String)
    case getAtPath(_ urlString: String)
    case getMyGists
    case getMyStarred
    case getPublic
    case isStarred(id: String)
    case star(id: String)
    case unstar(id: String)

    func asURLRequest() throws -> URLRequest {
        var method: HTTPMethod {
            switch self {
            case .create:
                return .post
            case .delete:
                return .delete
            case .getAtPath:
                return .get
            case .getMyGists:
                return .get
            case .getMyStarred:
                return .get
            case .getPublic:
                return .get
            case .isStarred:
                return .get
            case .star:
                return .put
            case .unstar:
                return .delete
            }
        }

        let url: URL = {
            switch self {
            case let .create:
                return createURL(withPath: "gists")
            case let .delete(id):
                return createURL(withPath: "gists/\(id)")
            case let .getAtPath(urlString):
                // already have the full URL, so just return it
                return URL(string: urlString)!
            case .getMyGists:
                return createURL(withPath: "gists")
            case .getMyStarred:
                return createURL(withPath: "gists/starred")
            case .getPublic:
                return createURL(withPath: "gists/public")
            case let .isStarred(id):
                return createURL(withPath: "gists/\(id)/star")
            case let .star(id):
                return createURL(withPath: "gists/\(id)/star")
            case let .unstar(id):
                return createURL(withPath: "gists/\(id)/star")
            }
        }()

        let data: Data? = {
            switch self {
            case let .create(data):
                return data
            default:
                return nil
            }
        }()

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.httpBody = data

        // Set OAuth token if we have one
        if let token = GitHubAPIManager.shared.oAuthToken {
            urlRequest.setValue("token \(token)", forHTTPHeaderField: "Authorization")
        }

        return urlRequest
    }

    func createURL(withPath path: String) -> URL {
        var url = URL(string: GistRouter.baseURLString)!
        url.appendPathComponent(path)
        return url
    }
}

