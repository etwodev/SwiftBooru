//
//  SafebooruPost.swift
//  SwiftBooru
//
//  Created by Ethan Woods on 16/03/2023.
//

import Foundation

struct SafebooruPost: Codable {
    let directory: String
    let hash: String
    let fileHeight: Int
    let pid: Int
    let image: String
    let change: Int
    let owner: String
    let parentID: Int
    let post_rating: Rating
    let sample: Bool
    let sampleHeight: Int
    let sampleWidth: Int
    let score: Int?
    let post_tags: String
    let fileWidth: Int

    enum CodingKeys: String, CodingKey {
        case directory = "directory"
        case hash = "hash"
        case fileHeight = "height"
        case pid = "id"
        case image = "image"
        case change = "change"
        case owner = "owner"
        case parentID = "parent_id"
        case post_rating = "rating"
        case sample = "sample"
        case sampleHeight = "sample_height"
        case sampleWidth = "sample_width"
        case score = "score"
        case post_tags = "tags"
        case fileWidth = "width"
    }
}

extension SafebooruPost: PostFormat, Hashable {
    var file: String { return "https://safebooru.org/images/\(directory)/\(image)" }
    var preview: String { return "https://safebooru.org/thumbnails/\(directory)/thumbnail_\(URL(fileURLWithPath: image).deletingPathExtension().lastPathComponent).jpg" }
    var tags: String { return post_tags }
    var height: Int { return fileHeight  }
    var width: Int { return fileWidth }
    var rating: Rating { return post_rating }
    var id: String { return hash + String(pid) }
}

typealias SafebooruPosts = [SafebooruPost]
