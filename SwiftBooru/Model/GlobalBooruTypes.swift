//
//  GlobalBooruTypes.swift
//  SwiftBooru
//
//  Created by Ethan Woods on 16/03/2023.
//

import Foundation

enum Rating: String, Codable {
    case explicit = "explicit"
    case general = "general"
    case safe = "safe"
    case questionable = "questionable"
    case sensitive = "sensitive"
}

enum ImageType {
    case unknown
    case image
    case video
}

protocol ImageFormat: Identifiable {
    var file: String { get }
    var preview: String { get }
    var tags: String { get }
    var height: Int { get }
    var width: Int { get }
    var rating: Rating { get }
    
    func getType() -> ImageType
    func getTags() -> [String]
}

extension ImageFormat {
    func getType() -> ImageType {
        let imageRegex = try! NSRegularExpression(pattern: ".(jpeg|jpg|png|gif|webp)$", options: .caseInsensitive)
        let videoRegex = try! NSRegularExpression(pattern: ".(mp4|mov|mkv|webm)$", options: .caseInsensitive)

        if imageRegex.firstMatch(in: file, options: [], range: NSRange(location: 0, length: file.count)) != nil {
            return .image
        } else if videoRegex.firstMatch(in: file, options: [], range: NSRange(location: 0, length: file.count)) != nil {
            return .video
        } else {
            return .unknown
        }
    }
    
    func getTags() -> [String] {
        return tags.components(separatedBy: " ")
    }
}
