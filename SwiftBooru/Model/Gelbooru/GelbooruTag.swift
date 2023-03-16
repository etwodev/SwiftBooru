//
//  GelbooruTag.swift
//  SwiftBooru
//
//  Created by Ethan Woods on 16/03/2023.
//

import Foundation

struct GelbooruTag: Codable {
    let type: Category
    let label: String
    let value: String
    let postCount: String
    let category: Category

    enum CodingKeys: String, CodingKey {
        case type = "type"
        case label = "label"
        case value = "value"
        case postCount = "post_count"
        case category = "category"
    }
}

enum Category: String, Codable {
    case metadata = "metadata"
    case tag = "tag"
}

extension GelbooruTag: Identifiable {
    var id: String { return value }
}

typealias GelbooruTags = [GelbooruTag]

