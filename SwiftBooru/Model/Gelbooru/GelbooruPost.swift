//
//  GelbooruPost.swift
//  SwiftBooru
//
//  Created by Ethan Woods on 16/03/2023.
//

import Foundation

struct GelbooruSearch: Codable {
    let attributes: GelbooruAttribute
    let post: GelbooruPosts

    enum CodingKeys: String, CodingKey {
        case attributes = "@attributes"
        case post = "post"
    }
}

struct GelbooruAttribute: Codable {
    let limit: Int
    let offset: Int
    let count: Int

    enum CodingKeys: String, CodingKey {
        case limit = "limit"
        case offset = "offset"
        case count = "count"
    }
}

struct GelbooruPost: Codable {
    let id: Int
    let createdAt: String
    let score: Int
    let width: Int
    let height: Int
    let md5: String
    let directory: String
    let image: String
    let rating: BooruRating
    let source: String
    let change: Int
    let owner: String
    let creatorID: Int
    let parentID: Int
    let sample: Int
    let previewHeight: Int
    let previewWidth: Int
    let tags: String
    let title: String
    let hasNotes: String
    let hasComments: String
    let fileURL: String
    let previewURL: String
    let sampleURL: String
    let sampleHeight: Int
    let sampleWidth: Int
    let status: Status
    let postLocked: Int
    let hasChildren: String

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case createdAt = "created_at"
        case score = "score"
        case width = "width"
        case height = "height"
        case md5 = "md5"
        case directory = "directory"
        case image = "image"
        case rating = "rating"
        case source = "source"
        case change = "change"
        case owner = "owner"
        case creatorID = "creator_id"
        case parentID = "parent_id"
        case sample = "sample"
        case previewHeight = "preview_height"
        case previewWidth = "preview_width"
        case tags = "tags"
        case title = "title"
        case hasNotes = "has_notes"
        case hasComments = "has_comments"
        case fileURL = "file_url"
        case previewURL = "preview_url"
        case sampleURL = "sample_url"
        case sampleHeight = "sample_height"
        case sampleWidth = "sample_width"
        case status = "status"
        case postLocked = "post_locked"
        case hasChildren = "has_children"
    }
}

enum Status: String, Codable {
    case active = "active"
}

typealias GelbooruPosts = [GelbooruPost]
