//
//  StravaRouter.swift
//  CommuteNumbers
//
//  Created by Michael Charland on 2019-09-02.
//  Copyright © 2019 charland. All rights reserved.
//

import Alamofire
import Foundation

enum StravaRouter: URLRequestConvertible {
    static let baseURLString = "https://www.strava.com/api/v3/"

    case activities

    case getAtPath(_ urlString: String)
    case getMyStarred
    case getPublic

    func asURLRequest() throws -> URLRequest {
        var method: HTTPMethod {
            switch self {
            case .getAtPath:
                return .get
            case .getMyStarred:
                return .get
            case .getPublic:
                return .get
            case .activities:
                return .get
            }
        }

        let url: URL = {
            switch self {
            case .activities:
                let relativePath = "athlete/activities"
                var url = URL(string: StravaRouter.baseURLString)!
                url.appendPathComponent(relativePath)
                return url
            case let .getAtPath(urlString):
                // already have the full URL, so just return it
                return URL(string: urlString)!
            case .getMyStarred:
                let relativePath = "gists/starred"
                var url = URL(string: StravaRouter.baseURLString)!
                url.appendPathComponent(relativePath)
                return url
            case .getPublic:
                let relativePath = "gists/public"
                var url = URL(string: StravaRouter.baseURLString)!
                url.appendPathComponent(relativePath)
                return url
            }
        }()

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        print (url)

        // Set OAuth token if we have one
        if let token = StravaAPIManager.shared.OAuthToken {
            urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        return urlRequest
    }
}
