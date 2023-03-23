//
//  SafebooruTag.swift
//  SwiftBooru
//
//  Created by Ethan Woods on 16/03/2023.
//

import Foundation

struct SafebooruTag: Codable {
    let label: String
    let value: String

    enum CodingKeys: String, CodingKey {
        case label = "label"
        case value = "value"
    }
}

extension SafebooruTag: Identifiable, TagFormat {
    var id: String { return value }
}

typealias SafebooruTags = [SafebooruTag]
