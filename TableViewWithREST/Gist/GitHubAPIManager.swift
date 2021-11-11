//
//  GitHubAPIManager.swift
//  TableViewWithREST
//
//  Created by Michael Charland on 2019-08-23.
//  Copyright © 2019 charland. All rights reserved.
//

import Alamofire
import Foundation
import Locksmith

class GitHubAPIManager {
    static let shared = GitHubAPIManager()
    var isLoadingOAuthToken = false

    // handler for the OAuth process
    // stored as var since sometimes it requires a round trip to safari which
    // makes it hard to just keep a reference to it
    var oAuthTokenCompletionHandler:((Error?) -> Void)?

    var oAuthToken: String?
    {
        set {
            guard let newValue = newValue else {
                let _ = try? Locksmith.deleteDataForUserAccount(userAccount: "github")
                return
            }
            guard let _ = try? Locksmith.updateData(data: ["token": newValue], forUserAccount: "github") else {
                let _ = try? Locksmith.deleteDataForUserAccount(userAccount: "github")
                return
            }
        }
        get {
            // try to load data from Keychain
            let dictionary = Locksmith.loadDataForUserAccount(userAccount: "github")
            return dictionary?["token"] as? String
        }
    }

    func imageFrom(url: URL, completionHandler: @escaping (UIImage?, Error?) -> Void) {
        AF.request(url).responseData { response in
            guard let data = response.data else {
                completionHandler(nil, response.error)
                return
            }
            let image = UIImage(data: data)
            completionHandler(image, nil)
        }
    }

    func parseNextPageFromHeaders(response: HTTPURLResponse?) -> String? {
        guard let linkHeader = response?.allHeaderFields["Link"] as? String else {
            return nil }
        // looks like: <https://...?page=2>; rel="next", <https://...?page=6>; rel="last"
        // so split on ","
        let components = linkHeader.components(separatedBy: ",")
        // now we have separate lines like '<https://...?page=2>; rel="next"'
        for item in components {
            // see if it's "next"
            let rangeOfNext = item.range(of: "rel=\"next\"", options: [])
            guard rangeOfNext != nil else { continue }
            // this is the "next" item, extract the URL
            let rangeOfPaddedURL = item.range(of: "<(.*)>;",
                                              options: .regularExpression,
                                              range: nil,
                                              locale: nil)
            guard let range = rangeOfPaddedURL else {
                return nil
            }
            // strip off the < and >;
            let start = item.index(range.lowerBound, offsetBy: 1)
            let end = item.index(range.upperBound, offsetBy: -2)
            let trimmedSubstring = item[start..<end]
            return String(trimmedSubstring)
        }
        return nil
    }

    func clearCache() {
        let cache = URLCache.shared
        cache.removeAllCachedResponses()
    }

    func printMashapeRouterRequest() {
        AF.request(MashapeRouter.getDefinition("hipster")) .responseString { response in
            if let result = response.value { print(result)
            }
        }
    }

    // MARK: - OAuth flow

    func hasOAuthToken() -> Bool {
        if let token = self.oAuthToken {
            return !token.isEmpty
        }
        return false
    }

    func printMyStarredGistsWithOAuth2() {
        AF.request(GistRouter.getMyStarred)
            .responseString { response in
                guard let receivedString = response.value else {
                    print("didn't get a string in the response")
                    return
                }
                print(receivedString)
        }
    }

    func convertURLToStartOAuth2Login() -> URL? {
        let authPath: String = "https://github.com/login/oauth/authorize" +
        "?client_id=\(GitHubOAuthKeys.clientID)&scope=repo,gist&state=TEST_STATE"
        return URL(string: authPath)
    }

    func processOAuthStep1Response(_ url: URL) {
        // extract the code from the URL
        guard let code = extractCodeFromOAuthStep1Response(url) else {
            isLoadingOAuthToken = false
            let error = BackendError.authCouldNot(reason: "Could not obtain an OAuth token")
            oAuthTokenCompletionHandler?(error)
            return
        }

        swapAuthCodeForToken(code: code)
    }

    func extractCodeFromOAuthStep1Response(_ url: URL) -> String? {
        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        var code: String?
        guard let queryItems = components?.queryItems else {
            isLoadingOAuthToken = false
            return nil
        }
        for queryItem in queryItems {
            if (queryItem.name.lowercased() == "code") {
                code = queryItem.value
                break
            }
        }
        return code
    }

    func swapAuthCodeForToken(code: String) {
        let getTokenPath = "https://github.com/login/oauth/access_token"
        let tokenParams = ["client_id": GitHubOAuthKeys.clientID,
                           "client_secret": GitHubOAuthKeys.clientSecret,
                           "code": code]
        let jsonHeader = HTTPHeaders(["Accept": "application/json"])
        AF.request(
            getTokenPath,
            method: .post,
            parameters: tokenParams,
            encoding: URLEncoding.default,
            headers: jsonHeader)
            .responseJSON { response in

            guard response.error == nil else {
                self.isLoadingOAuthToken = false
                let errorMessage = response.error?.localizedDescription ?? "Could not obtain an OAuth token"
                let error = BackendError.authCouldNot(reason: errorMessage)
                self.oAuthTokenCompletionHandler?(error)
                return
            }
            guard let value = response.value else {
                self.isLoadingOAuthToken = false
                let errorMessage = response.error?.localizedDescription ?? "Could not obtain an OAuth token"
                let error = BackendError.authCouldNot(reason: errorMessage)
                self.oAuthTokenCompletionHandler?(error)
                return
            }
            guard let jsonResult = value as? [String: String] else {
                self.isLoadingOAuthToken = false
                let errorMessage = response.error?.localizedDescription ?? "Could not obtain an OAuth token"
                let error = BackendError.authCouldNot(reason: errorMessage)
                self.oAuthTokenCompletionHandler?(error)
                return
            }
            print(jsonResult)
            // like {"access_token": "9999999", "token_type": "bearer", "scope": "gist"}
            self.oAuthToken = self.parseOAuthTokenResponse(jsonResult)

            self.isLoadingOAuthToken = false
            guard self.hasOAuthToken() else {
                return
            }
            if self.hasOAuthToken() {
                self.oAuthTokenCompletionHandler?(nil)
            } else {
                let error = BackendError.authCouldNot(reason: "Could not obtain an OAuth token")
                self.oAuthTokenCompletionHandler?(error)
            }
        }
    }

    func parseOAuthTokenResponse(_ json: [String: String]) -> String? {
        var token: String?
        for (key, value) in json {
            switch key {
            case "access_token":
                token = value
            case "scope":
                // TODO: verify scope
                print("SET SCOPE")
            case "token_type":
                // TODO: verify is bearer
                print("CHECK IF BEARER")
            default:
                print("got more than 1 expected from the OAuth token exchange")
                print(key)
            }
        }
        return token
    }

    func checkUnauthorized(urlResponse: HTTPURLResponse) -> (Error?) {
        if (urlResponse.statusCode == 401) {
            self.oAuthToken = nil
            return BackendError.authLost(reason: "Not Logged In")
        }
        return nil
    }

    func isAPIOnline(completionHandler: @escaping (Bool) -> Void ) {
        AF.request(GistRouter.baseURLString)
            .validate(statusCode: 200..<300)
            .responseData { response in
                switch response.result {
                case .success:
                    completionHandler(true)
                case .failure:
                    completionHandler(false)
            }
        }
    }
}
