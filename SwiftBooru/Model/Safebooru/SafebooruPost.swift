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
    let height: Int
    let id: Int
    let image: String
    let change: Int
    let owner: String
    let parentID: Int
    let rating: BooruRating
    let sample: Bool
    let sampleHeight: Int
    let sampleWidth: Int
    let score: Int?
    let tags: String
    let width: Int

    enum CodingKeys: String, CodingKey {
        case directory = "directory"
        case hash = "hash"
        case height = "height"
        case id = "id"
        case image = "image"
        case change = "change"
        case owner = "owner"
        case parentID = "parent_id"
        case rating = "rating"
        case sample = "sample"
        case sampleHeight = "sample_height"
        case sampleWidth = "sample_width"
        case score = "score"
        case tags = "tags"
        case width = "width"
    }
}

typealias SafebooruPosts = [SafebooruPost]
