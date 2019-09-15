//
//  CircleCIRouter.swift
//  TableViewWithREST
//
//  Created by Michael Charland on 2019-09-02.
//  Copyright © 2019 charland. All rights reserved.
//

import Alamofire
import Foundation

enum CircleCIRouter: URLRequestConvertible {
    private static let baseURLString = "https://circleci.com/api/v1.1/"
    private static let apiKey = CircleCIAPIKeys.api

    case me
    case projects
    case singleJob(vcsType: String, username: String, project: String, buildNum: String)

    func asURLRequest() throws -> URLRequest {
        var method: HTTPMethod {
            switch self {
            case .me:
                return .get
            case .projects:
                return .get
            case .singleJob:
                return .get
            }
        }

        let url: URL = {
            switch self {
            case .me:
                let relativePath = "me"
                var url = URL(string: CircleCIRouter.baseURLString)!
                url.appendPathComponent(relativePath)
                return url
            case .projects:
                let relativePath = "projects"
                var url = URL(string: CircleCIRouter.baseURLString)!
                url.appendPathComponent(relativePath)
                return url
            case let .singleJob(vcsType, username, project, buildNum):
                let relativePath = "project"
                var url = URL(string: CircleCIRouter.baseURLString)!
                url.appendPathComponent(relativePath)
                url.appendPathComponent(vcsType)
                url.appendPathComponent(username)
                url.appendPathComponent(project)
                url.appendPathComponent(buildNum)
                return url
            }
        }()

        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        urlComponents.queryItems = [
            URLQueryItem(name: "circle-token", value: CircleCIRouter.apiKey)
        ]

        var urlRequest = URLRequest(url: urlComponents.url!)
        urlRequest.httpMethod = method.rawValue
        return urlRequest
    }
}

