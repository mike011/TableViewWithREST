//
//  Networking.swift
//  TableViewWithREST
//
//  Created by Michael Charland on 2019-08-23.
//  Copyright © 2019 charland. All rights reserved.
//

import Alamofire
import Foundation

extension JSONDecoder {

    func decodeResponse2<T: Decodable>(from response: DataResponse<Data>) -> Result<T, Error> {

        guard response.error == nil else {
            // got an error in getting the data, need to handle it
            print(response.error!)
            return .failure(BackendError.network(error: response.error!))
        }

        // make sure we got JSON and it's a dictionary
        guard let responseData = response.data else {
            print("didn't get any data from API")
            return .failure(BackendError.unexpectedResponse(reason: "Did not get data in response"))
        }

        // check for "message" errors in the JSON because this API does that
        if let apiProvidedError = try? self.decode(APIProvidedError.self, from: responseData) {
            return .failure(BackendError.apiProvidedError(reason: apiProvidedError.message))
        }

        // turn data into expected type
        do {
            let item = try
                self.decode(T.self, from: responseData)
            return .success(item)
        } catch {
            print("error trying to decode response")
            print(error)
            return .failure(BackendError.parsing(error: error))
        }
    }

    func decodeResponse<T: Decodable>(from response: DataResponse<Data>) -> Result<T, Error> {
        guard response.error == nil else {
            // got an error in getting the data, need to handle it
            print(response.error!)
            return .failure(BackendError.network(error: response.error!))
        }
        
        // make sure we got JSON and it's a dictionary
        guard let responseData = response.data else {
            print("didn't get any data from API")
            return .failure(BackendError.unexpectedResponse(reason: "Did not get data in response"))
        }

        // check for "message" errors in the JSON because this API does that
        if let apiProvidedError = try? self.decode(APIProvidedError.self, from: responseData) {
            return .failure(BackendError.apiProvidedError(reason: apiProvidedError.message))
        }

        // turn data into expected type
        do {
            let item = try
                self.decode(T.self, from: responseData)
            return .success(item)
        } catch {
            print("error trying to decode response")
            print(error)
            return .failure(BackendError.parsing(error: error))
        }
    }
}
