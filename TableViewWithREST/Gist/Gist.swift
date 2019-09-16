//
//  Gist.swift
//  TableViewWithREST
//
//  Created by Michael Charland on 2019-08-23.
//  Copyright © 2019 charland. All rights reserved.
//

import Foundation

struct GistOwner: Codable {
    var login: String
    var avatarURL: URL?

    enum CodingKeys: String, CodingKey {
        case login
        case avatarURL = "avatar_url"
    }
}

struct File: Codable {
    var filename: String
    var url: URL

    enum CodingKeys: String, CodingKey {
        case filename
        case url = "raw_url"
    }
}

struct Gist: Codable {
    
    var id: String
    var gistDescription: String?
    var url: URL
    var owner: GistOwner?
    let createdAt: Date
    let updatedAt: Date
    let files: [String: File] // JSON does filename: { file data }
    lazy var orderedFiles: [(name: String, details: File)] = {
        var orderedFiles = [(name: String, details: File)]()
        for (key, value) in files {
            let item = (name: key, details: value)
            orderedFiles.append(item)
        }
        return orderedFiles
    }()

    enum CodingKeys: String, CodingKey {
        case id
        case gistDescription = "description"
        case url
        case owner
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case files
    }
}
