//
//  GlobalBooruTypes.swift
//  SwiftBooru
//
//  Created by Ethan Woods on 16/03/2023.
//

import Foundation


enum BooruRating: String, Codable {
    case explicit = "explicit"
    case general = "general"
    case safe = "safe"
    case questionable = "questionable"
    case sensitive = "sensitive"
}
