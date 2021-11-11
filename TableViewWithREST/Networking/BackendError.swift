//
//  BackendError.swift
//  TableViewWithREST
//
//  Created by Michael Charland on 2019-08-23.
//  Copyright © 2019 charland. All rights reserved.
//

import Foundation
import Alamofire

enum BackendError: Error {
    case request(error: Error)
    case network(error: Error)
    case unexpectedResponse(reason: String)
    case parsing(error: Error)
    case apiProvidedError(reason: String)
    case authCouldNot(reason: String)
    case authLost(reason: String)
    case missingRequiredInput(reason: String)
}

struct APIProvidedError: Codable {
    let message: String
}
