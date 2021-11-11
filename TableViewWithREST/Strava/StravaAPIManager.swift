//
//  StravaAPIManager.swift
//  CommuteNumbers
//
//  Created by Michael Charland on 2019-09-02.
//  Copyright © 2019 charland. All rights reserved.
//

import Alamofire
import Foundation
import Locksmith

class StravaAPIManager {
    static let shared = StravaAPIManager()

    // MARK: - Authentication

    var isLoadingOAuthToken = false

    // handler for the OAuth process
    // stored as var since sometimes it requires a round trip to safari which
    // makes it hard to just keep a reference to it
    var oAuthTokenCompletionHandler:((Error?) -> Void)?

    var OAuthToken: String?
    {
        set {
            guard let newValue = newValue else {
                let _ = try? Locksmith.deleteDataForUserAccount(userAccount: "strava")
                return
            }
            guard let _ = try? Locksmith.updateData(data: ["token": newValue], forUserAccount: "strava") else {
                let _ = try? Locksmith.deleteDataForUserAccount(userAccount: "strava")
                return
            }
        }
        get {
            // try to load data from Keychain
            let dictionary = Locksmith.loadDataForUserAccount(userAccount: "strava")
            return dictionary?["token"] as? String
        }
    }

    func URLToStartOAuth2Login() -> URL? {
        var authPath = "https://www.strava.com/oauth/authorize"
        authPath += "?client_id=\(StravaOAuthKeys.clientID)"
        authPath += "&redirect_uri=commutenumbers://localhost"
        authPath += "&response_type=code"
        authPath += "&approval_prompt=force"
        authPath += "&scope=activity:read"
        authPath += "&state=test"
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
        let getTokenPath = "https://www.strava.com/oauth/token"
        let tokenParams = ["client_id": StravaOAuthKeys.clientID,
                           "client_secret": StravaOAuthKeys.clientSecret,
                           "code": code,
                           "grant_type": "authorization_code"]
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
                guard let jsonResult = value as? [String: Any] else {
                    self.isLoadingOAuthToken = false
                    let errorMessage = response.error?.localizedDescription ?? "Could not obtain an OAuth token"
                    let error = BackendError.authCouldNot(reason: errorMessage)
                    self.oAuthTokenCompletionHandler?(error)
                    return
                }
                print(jsonResult)
                // like {"access_token": "9999999", "token_type": "bearer", "scope": "gist"}
                self.OAuthToken = self.parseOAuthTokenResponse(jsonResult)

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

    func hasOAuthToken() -> Bool {
        if let token = self.OAuthToken {
            return !token.isEmpty
        }
        return false
    }

    func parseOAuthTokenResponse(_ json: [String: Any]) -> String? {
        var token: String?
        for (key, value) in json {
            switch key {
            case "access_token":
                token = value as? String
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
}

extension StravaAPIManager {

    func getActivities(completionHandler: @escaping (Result<[Exercise], Error>, String?) -> Void) {
        AF.request(StravaRouter.activities).responseData { (response) in
            if let urlResponse = response.response,
                let authError = self.checkUnauthorized(urlResponse: urlResponse) {
                completionHandler(.failure(authError), nil)
                return
            }
            let decoder = JSONDecoder()
            let result: Result<[Exercise], Error> = decoder.decodeResponse(from: response)
            //let next = self.parseNextPageFromHeaders(response: response.response)
            completionHandler(result, nil)
        }
    }

    func checkUnauthorized(urlResponse: HTTPURLResponse) -> (Error?) {
        if (urlResponse.statusCode == 401) {
            self.OAuthToken = nil
            return BackendError.authLost(reason: "Not Logged In")
        }
        return nil
    }
}
