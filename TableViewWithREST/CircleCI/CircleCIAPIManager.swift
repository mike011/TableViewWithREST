//
//  CircleCIAPIManager.swift
//  TableViewWithREST
//
//  Created by Michael Charland on 2019-09-02.
//  Copyright © 2019 charland. All rights reserved.
//

import Alamofire
import Foundation

class CircleCIAPIManager {
    static let shared = CircleCIAPIManager()

    // MARK:
    func printInfoAboutMe() {
        AF.request(CircleCIRouter.me)
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

    func printProjects() {
        AF.request(CircleCIRouter.projects)
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

    func printSingleJob() {
        for i in 48000..<48300 {
        AF.request(CircleCIRouter.singleJob(vcsType: "github", username: "Enflick", project: "textnow-ios5", buildNum: "\(i)"))
            .responseData(completionHandler: { response in
                switch response.result {
                case .success:
                    guard response.error == nil else {
                        print("for id \(i) failed with: \(response.error)")
                        return
                    }

                    let decoder = JSONDecoder()
                    let result: Result<Project, Error> = decoder.decodeResponse(from: response)

                    switch result {
                        case let .success(data):
                            var out = "\(i)"
                            out += "\t\(data.buildParameters.circleJob)"
                            out += "\t\(data.startTime)"
                            out += "\t\(data.buildTimeMillis)"
                        case .failure(let failure):
                            print(failure)
                    }
                case .failure(let failure):
                    print(failure)
                }
            })
        }
    }
}
