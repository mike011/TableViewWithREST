//
//  DarkSkyRouter.swift
//  TableViewWithREST
//
//  Created by Michael Charland on 2019-09-02.
//  Copyright © 2019 charland. All rights reserved.
//

import Alamofire
import Foundation

enum DarkSkyRouter: URLRequestConvertible {
    private static let baseURLString = "https://api.darksky.net/"
    private static let apiKey = DarkSkyAPIKeys.api

    case forecast(location: String)

    func asURLRequest() throws -> URLRequest {
        var method: HTTPMethod {
            switch self {
            case .forecast:
                return .get
            }
        }

        let url: URL = {
            switch self {
            case let .forecast(gps):
                let relativePath = "forecast"
                var url = URL(string: DarkSkyRouter.baseURLString)!
                url.appendPathComponent(relativePath)
                url.appendPathComponent(DarkSkyRouter.apiKey)
                url.appendPathComponent(gps)
                return url
            }
        }()

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        return urlRequest
    }
}

