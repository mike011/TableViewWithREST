// From: https://app.quicktype.io

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let pocketMyList = try? newJSONDecoder().decode(PocketMyList.self, from: jsonData)

import Foundation

// MARK: - UnTaggedPocketMyList
struct UnTaggedPocketMyList: Decodable {
    let status, complete: Int
    let pockedItems: [String]?
    enum CodingKeys: String, CodingKey {
        case status, complete
        case pockedItems = "list"
    }
}

// MARK: - PocketMyList
struct PocketMyList: Decodable {
    let status, complete: Int
    let pockedItems: [String: PockedItemResponse]
    enum CodingKeys: String, CodingKey {
        case status, complete
        case pockedItems = "list"
    }
}

// MARK: - List
struct PockedItemResponse: Decodable {
    let itemID, resolvedID: String
    let givenURL: String
    let givenTitle, favorite, status, timeAdded: String
    let timeUpdated, timeRead, timeFavorited: String
    let sortID: Int
    let resolvedTitle: String
    let resolvedURL: String
    let excerpt, isArticle, isIndex, hasVideo: String
    let hasImage, wordCount, lang: String
    let domainMetadata: DomainMetadata?
    let listenDurationEstimate: Int
    let tags: [String: Tag]?

    enum CodingKeys: String, CodingKey {
        case itemID = "item_id"
        case resolvedID = "resolved_id"
        case givenURL = "given_url"
        case givenTitle = "given_title"
        case favorite, status
        case timeAdded = "time_added"
        case timeUpdated = "time_updated"
        case timeRead = "time_read"
        case timeFavorited = "time_favorited"
        case sortID = "sort_id"
        case resolvedTitle = "resolved_title"
        case resolvedURL = "resolved_url"
        case excerpt
        case isArticle = "is_article"
        case isIndex = "is_index"
        case hasVideo = "has_video"
        case hasImage = "has_image"
        case wordCount = "word_count"
        case lang
        case domainMetadata = "domain_metadata"
        case listenDurationEstimate = "listen_duration_estimate"
        case tags
    }
}

// MARK: - Tag
struct Tag: Decodable {
    let tag: String

    enum CodingKeys: String, CodingKey {
        case tag
    }
}

// MARK: - DomainMetadata
struct DomainMetadata: Decodable {
    let name: String
    let logo, greyscaleLogo: String

    enum CodingKeys: String, CodingKey {
        case name, logo
        case greyscaleLogo = "greyscale_logo"
    }
}
