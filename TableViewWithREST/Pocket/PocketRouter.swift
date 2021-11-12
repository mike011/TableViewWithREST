//
//  PocketRouter.swift
//  TableViewWithREST
//
//  Created by Michael Charland on 2021-11-07.
//  Copyright © 2019 charland. All rights reserved.
//

import Alamofire
import Foundation

enum PocketRouter: URLRequestConvertible {
    private static let baseURLString = "https://getpocket.com/v3/"
    private static let consumerKey = PocketOAuthKeys.consumerKey

    case request
    case authorize(code: String)
    case get(token: String, tagType: String? = nil)

    func asURLRequest() throws -> URLRequest {
        var method: HTTPMethod {
            return .post
        }

        let url: URL = {
            switch self {
            case .request:
                var url = URL(string: PocketRouter.baseURLString)!
                url.appendPathComponent("oauth/request")
                return url
            case .authorize:
                var url = URL(string: PocketRouter.baseURLString)!
                url.appendPathComponent("oauth/authorize")
                return url
            case .get:
                var url = URL(string: PocketRouter.baseURLString)!
                url.appendPathComponent("get")
                return url
            }
        }()

        let params: ([String: Any]?) = {
            switch self {
            case .request:
                return ["consumer_key": PocketRouter.consumerKey,
                        "redirect_uri": "pocket://localhost"]
            case .authorize(let code):
                return ["consumer_key": PocketRouter.consumerKey,
                        "code": code]
            case .get(let token, let tagType):
                var getParams = ["consumer_key": PocketRouter.consumerKey,
                                  "access_token": token,
                                  "detailType": "complete",
                                  "sort": "oldest"]
                if let tagType = tagType {
                    getParams["tag"] = tagType
                }
                return getParams
            }
        }()

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue

        let encoding = URLEncoding.default
        return try encoding.encode(urlRequest, with: params)
    }
}
