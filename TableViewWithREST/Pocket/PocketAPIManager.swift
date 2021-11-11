//
//  PocketAPIManager.swift
//  TableViewWithREST
//
//  Created by Michael Charland on 2021-11-07.
//  Copyright © 2021 charland. All rights reserved.
//

import Alamofire
import Foundation
import Locksmith

class PocketAPIManager {
    static let shared = PocketAPIManager()
    var isLoadingOAuthToken = false
    private var requestToken: String?

    // handler for the OAuth process
    // stored as var since sometimes it requires a round trip to safari which
    // makes it hard to just keep a reference to it
    var oAuthTokenCompletionHandler:((Error?) -> Void)?

    var oAuthToken: String?
    {
        set {
            guard let newValue = newValue else {
                let _ = try? Locksmith.deleteDataForUserAccount(userAccount: "pocket")
                return
            }
            guard let _ = try? Locksmith.updateData(data: ["token": newValue], forUserAccount: "pocket") else {
                let _ = try? Locksmith.deleteDataForUserAccount(userAccount: "pocket")
                return
            }
        }
        get {
            // try to load data from Keychain
            let dictionary = Locksmith.loadDataForUserAccount(userAccount: "pocket")
            return dictionary?["token"] as? String
        }
    }

    func hasOAuthToken() -> Bool {
        if let token = self.oAuthToken {
            return !token.isEmpty
        }
        return false
    }

    func requestToken(completionHandler: @escaping (Result<String,Error>) -> Void) {
        AF.request(PocketRouter.request)
            .responseData(completionHandler: { response in
                switch response.result {
                case .success(let data):
                    let stringData = String(decoding: data, as: UTF8.self)
                    let code = String(stringData.split(separator: "=")[1])
                    self.requestToken = code
                    completionHandler(.success(code))
                case .failure(let failure):
                    completionHandler(.failure(BackendError.request(error: failure)))
                }
            })
    }

    func convertURLToStartOAuth2Login(_ requestToken: String) -> URL? {
        let redirectURI = "pocket://localhost"
        let path = "https://getpocket.com/auth/authorize?request_token=\(requestToken)&redirect_uri=\(redirectURI)?mobile=1"
        return URL(string: path)
    }
    
    func processOAuthStep1Response() {
        guard let requestToken = requestToken else {
            return
        }
        swapAuthCodeForToken(code: requestToken)
    }

    func swapAuthCodeForToken(code: String) {
        authorize(requestToken: code, completionHandler: { result in
            switch result {
            case .success(let authorizeToken):
                self.isLoadingOAuthToken = false

                self.oAuthToken = authorizeToken

                guard self.hasOAuthToken() else {
                    return
                }
                if self.hasOAuthToken() {
                    self.oAuthTokenCompletionHandler?(nil)
                } else {
                    let error = BackendError.authCouldNot(reason: "Could not obtain an OAuth token")
                    self.oAuthTokenCompletionHandler?(error)
                }
            case .failure(let error):
                self.isLoadingOAuthToken = false
                let errorMessage = error.localizedDescription
                let error = BackendError.authCouldNot(reason: errorMessage)
                self.oAuthTokenCompletionHandler?(error)
            }
        })
    }

    func authorize(requestToken: String, completionHandler: @escaping (Result<String,Error>) -> Void) {
        AF.request(PocketRouter.authorize(code: requestToken))
            .responseData(completionHandler: { response in
                switch response.result {
                case .success(let data):
                    let stringData = String(decoding: data, as: UTF8.self)
                    let accessToken = String(stringData.split(separator: "=")[1])
                    completionHandler(.success(accessToken))
                case .failure(let failure):
                    completionHandler(.failure(BackendError.request(error: failure)))
                }
            })
    }


    // MARK:
    func getItems() {
        AF.request(PocketRouter.get)
            .responseJSON(completionHandler: { response in
                switch response.result {
                case .success(let data):
                    print("here")
                    print(data)
                case .failure(let failure):
                    print(failure)
                }
            })
    }
}
