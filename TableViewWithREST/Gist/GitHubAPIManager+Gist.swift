//
//  GitHubAPIManager+Gist.swift
//  TableViewWithREST
//
//  Created by Michael Charland on 2019-09-08.
//  Copyright © 2019 charland. All rights reserved.
//

import Alamofire
import Foundation

extension GitHubAPIManager {

    // MARK: - Basic Auth
    func printMyStarredGistsWithBasicAuth() {
        AF.request(GistRouter.getMyStarred)
            .responseString { response in
                guard let receivedString = try? response.result.get() else {
                    print("didn't get a string in the response")
                    return
                }
                print(receivedString)
        }
    }

    func printPublicGists() {
        AF.request(GistRouter.getPublic).responseString { (response) in
            if let receievedString = response.value {
                print(receievedString)
            }
        }
    }

    func fetchMyGists(pageToLoad: String?, completionHandler: @escaping (Result<[Gist], Error>, String?) -> Void) {
        if let urlString = pageToLoad {
            fetchGists(GistRouter.getAtPath(urlString), completionHandler: completionHandler)
        } else {
            fetchGists(GistRouter.getMyGists, completionHandler: completionHandler)
        }
    }

    func fetchMyStarredGists(pageToLoad: String?, completionHandler: @escaping (Result<[Gist], Error>, String?) -> Void) {
        if let urlString = pageToLoad {
            fetchGists(GistRouter.getAtPath(urlString), completionHandler: completionHandler)
        } else {
            fetchGists(GistRouter.getMyStarred, completionHandler: completionHandler)
        }
    }

    func fetchPublicGists(pageToLoad: String?, completionHandler: @escaping (Result<[Gist], Error>, String?) -> Void) {
        if let urlString = pageToLoad {
            self.fetchGists(GistRouter.getAtPath(urlString), completionHandler: completionHandler)
        } else {
            self.fetchGists(GistRouter.getPublic, completionHandler: completionHandler)
        }
    }

    func fetchGists(_ urlRequest: URLRequestConvertible, completionHandler: @escaping (Result<[Gist], Error>, String?) -> Void) {
        AF.request(urlRequest).responseData { (response) in
            if let urlResponse = response.response,
                let authError = self.checkUnauthorized(urlResponse: urlResponse) {
                completionHandler(.failure(authError), nil)
                return
            }
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let result: Result<[Gist], Error> = decoder.decodeResponse(from: response)
            let next = self.parseNextPageFromHeaders(response: response.response)
            completionHandler(result, next)
        }
    }

    func isGistStarred(withID gistID: String, completionHandler: @escaping (Result<Bool,Error>) -> Void) {
        AF.request(GistRouter.isStarred(id: gistID))
            .validate(statusCode: [204]).responseData { (response) in
                if let urlResponse = response.response,
                    let authError = self.checkUnauthorized(urlResponse: urlResponse)
                {
                    completionHandler(.failure(authError))
                    return
                }

                switch response.result {
                case let .failure(error):
                    switch response.response?.statusCode {
                    case 404:
                        completionHandler(.success(false))
                    default:
                        completionHandler(.failure(error))
                    }
                    return
                case .success:
                    completionHandler(.success(true))
                    return
            }
        }
    }

    func starGist(withID gistID: String, completionHandler: @escaping (Result<Any?, Error>) -> Void) {
        AF.request(GistRouter.star(id: gistID)).responseData { (response) in
            if let urlResponse = response.response,
                let authError = self.checkUnauthorized(urlResponse: urlResponse)
            {
                completionHandler(.failure(authError))
                return
            }

            switch(response.result) {
            case let .failure(error):
                completionHandler(.failure(error))
            case .success:
                completionHandler(.success(nil))
            }
        }
    }

    func unstarGist(withID gistID: String, completionHandler: @escaping (Result<Any?, Error>) -> Void) {
        AF.request(GistRouter.unstar(id: gistID)).responseData { (response) in
            if let urlResponse = response.response,
                let authError = self.checkUnauthorized(urlResponse: urlResponse)
            {
                completionHandler(.failure(authError))
                return
            }
            
            switch(response.result) {
            case let .failure(error):
                completionHandler(.failure(error))
            case .success:
                completionHandler(.success(nil))
            }
        }
    }
}
