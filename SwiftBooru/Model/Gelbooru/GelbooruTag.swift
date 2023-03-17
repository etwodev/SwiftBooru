//
//  GelbooruTag.swift
//  SwiftBooru
//
//  Created by Ethan Woods on 16/03/2023.
//

import Foundation

struct GelbooruTag: Codable {
    let type: String
    let label: String
    let value: String
    let postCount: String
    let category: String

    enum CodingKeys: String, CodingKey {
        case type = "type"
        case label = "label"
        case value = "value"
        case postCount = "post_count"
        case category = "category"
    }
}

extension GelbooruTag: Identifiable {
    var id: String { return value }
}

typealias GelbooruTags = [GelbooruTag]

