//
//  SafebooruPosts.swift
//  SwiftBooru
//
//  Created by Ethan Woods on 16/03/2023.
//

import Foundation

import Foundation

// MARK: - PostResponseElement
struct SafebooruPost: Codable {
    let directory: String
    let hash: String
    let height: Int
    let id: Int
    let image: String
    let change: Int
    let owner: Owner
    let parentID: Int
    let rating: Rating
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

enum Owner: String, Codable {
    case anonymous = "anonymous"
    case b3Beshe = "b3beshe"
    case bowserxpeach = "bowserxpeach"
    case danbooru = "danbooru"
}

enum Rating: String, Codable {
    case general = "general"
    case safe = "safe"
}

typealias PostResponse = [PostResponseElement]
