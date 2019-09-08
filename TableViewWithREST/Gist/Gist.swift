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

struct Gist: Codable {
    var id: String
    var gistDescription: String?
    var url: URL
    var owner: GistOwner?

    enum CodingKeys: String, CodingKey {
        case id
        case gistDescription = "description"
        case url
        case owner
    }

}
