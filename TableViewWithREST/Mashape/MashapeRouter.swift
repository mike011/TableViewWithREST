//
//  MashapeRouter.swift
//  TableViewWithREST
//
//  Created by Michael Charland on 2019-08-29.
//  Copyright © 2019 charland. All rights reserved.
//

import Alamofire
import Foundation

enum MashapeRouter: URLRequestConvertible {
    static let baseURLString = "https://mashape-community-urban-dictionary.p.rapidapi.com/"
    case getDefinition(String)

    func asURLRequest() throws -> URLRequest {

        var method: HTTPMethod {
            switch self {
            case .getDefinition:
                return .get
            }
        }

        let url: URL = {
            let relativePath: String
            switch self {
            case .getDefinition:
                relativePath = "define"
            }
            var url = URL(string: MashapeRouter.baseURLString)!
            url.appendPathComponent(relativePath)
            return url
        }()

        let params: ([String: Any]?) = {
            switch self {
            case .getDefinition(let wordToDefine):
                return ["term": wordToDefine] }
        }()

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        // include API key header
        urlRequest.setValue(MashapeAPIKeys.api, forHTTPHeaderField: "x-rapidapi-key")

        let encoding = URLEncoding.default
        return try encoding.encode(urlRequest, with: params)
    }
}
