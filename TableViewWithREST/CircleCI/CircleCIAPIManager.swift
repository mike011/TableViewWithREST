//
//  CircleCIAPIManager.swift
//  TableViewWithREST
//
//  Created by Michael Charland on 2019-09-02.
//  Copyright © 2019 charland. All rights reserved.
//

import Alamofire
import Foundation

final class CircleCIAPIManager: @unchecked Sendable {
    static let shared = CircleCIAPIManager()

    // MARK:
    func printInfoAboutMe() {
        AF.request(CircleCIRouter.me)
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

    func printProjects() {
        AF.request(CircleCIRouter.projects)
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

    func printSingleJob() {
        for i in 48000..<48300 {
            AF.request(CircleCIRouter.singleJob(vcsType: "github", username: "Enflick", project: "textnow-ios5", buildNum: "\(i)"))
                .responseData(completionHandler: { response in
                    switch response.result {
                    case .success:
                        guard response.error == nil else {
                            print("for id \(i) failed with: \(String(describing: response.error))")
                            return
                        }

                        let decoder = JSONDecoder()
                        let result: Result<Project, Error> = decoder.decodeResponse(from: response)

                        switch result {
                        case let .success(data):
                            var out = "\(i)"
                            out += "\t\(data.buildParameters.circleJob)"
                            out += "\t\(String(describing: data.startTime))"
                            out += "\t\(String(describing: data.buildTimeMillis))"
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
