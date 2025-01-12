//
//  DarkSkyAPIManager.swift
//  TableViewWithREST
//
//  Created by Michael Charland on 2019-09-02.
//  Copyright © 2019 charland. All rights reserved.
//

import Alamofire
import Foundation

final class DarkSkyAPIManager: @unchecked Sendable {
    static let shared = DarkSkyAPIManager()

    // MARK:
    func getForecast(location: String) {
        AF.request(DarkSkyRouter.forecast(location: location))
            .responseDecodable(of: String.self) { response in
                switch response.result {
                case .success(let data):
                    print("here")
                    print(data)
                case .failure(let failure):
                    print(failure)
                }
            }
    }
}
