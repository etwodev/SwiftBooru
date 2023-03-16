//
//  DanbooruTag.swift
//  SwiftBooru
//
//  Created by Ethan Woods on 16/03/2023.
//

import Foundation

struct DanbooruTag: Codable {
    let type: TypeEnum
    let label: String
    let value: String
    let category: Int
    let postCount: Int
    let antecedent: String?

    enum CodingKeys: String, CodingKey {
        case type = "type"
        case label = "label"
        case value = "value"
        case category = "category"
        case postCount = "post_count"
        case antecedent = "antecedent"
    }
}

enum TypeEnum: String, Codable {
    case tag = "tag"
    case tagAlias = "tag-alias"
}

extension DanbooruTag: Identifiable {
    var id: String { return value }
}

typealias DanbooruTags = [DanbooruTag]
