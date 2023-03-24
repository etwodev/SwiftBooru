//
//  GlobalBooruTypes.swift
//  SwiftBooru
//
//  Created by Ethan Woods on 16/03/2023.
//

import Foundation
import SwiftUI
import URLImage
import AVKit

enum Rating: String, Codable {
    case explicit = "explicit"
    case general = "general"
    case safe = "safe"
    case questionable = "questionable"
    case sensitive = "sensitive"
    
    var description : String {
      switch self {
      case .explicit: return "explicit"
      case .general: return "general"
      case .safe: return "safe"
      case .questionable: return "questionable"
      case .sensitive: return "sensitive"
      }
    }
}

enum ImageType: String, Codable {
    case unknown = "unknown"
    case image = "image"
    case video = "video"
    
    var description : String {
      switch self {
      case .unknown: return "unknown"
      case .image: return "image"
      case .video: return "video"
      }
    }
}

protocol PostFormat: Codable, Identifiable {
    var file: String { get }
    var preview: String { get }
    var tags: String { get }
    var height: Int { get }
    var width: Int { get }
    var rating: Rating { get }
    var id: String { get }
    var image: String { get }
    
    func getType() -> ImageType
    func getTags() -> [String]
    func getFile() -> AnyView
}

protocol TagFormat: Codable, Identifiable {
    var id: String { get }
    var label: String { get }
}

extension PostFormat {
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
    
    func getPreview() -> AnyView {
        return AnyView(
            URLImage(URL(string: preview)!) {
                EmptyView()
            } inProgress: { progress in
                ProgressView()
            } failure: { error, retry in
                VStack {
                        Text(error.localizedDescription)
                        Button("Retry", action: retry)
                }
            } content: { image in
                image
                    .centerCropped(radius: 10)
            }
        )
    }
    
    func getFile() -> AnyView {
        let fileType = getType()
        switch fileType {
        case .image:
            return AnyView(URLImage(URL(string: file)!) {
                EmptyView()
            } inProgress: { progress in
                ProgressView()
            } failure: { error, retry in
                VStack {
                        Text(error.localizedDescription)
                        Button("Retry", action: retry)
                }
            } content: { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: Swiftbooru.defaultCornerRadius1))
            })
        case .video:
            return AnyView(VideoPlay(player: AVPlayer(url: URL(string: file)!))
                .clipShape(RoundedRectangle(cornerRadius: Swiftbooru.defaultCornerRadius1)))
        default:
            return AnyView(Image("Fallback")
                .centerCropped(radius: Swiftbooru.defaultCornerRadius1))
        }
    }
}

struct VideoPlay : NSViewRepresentable {
    var player : AVPlayer
    
    func makeNSView(context: Context) -> AVPlayerView {
        let view = AVPlayerView()
        view.player = player
        view.videoGravity = .resizeAspect
        player.isMuted = true
        player.play()
        return view
    }
    
    func updateNSView(_ nsView: AVPlayerView, context: Context) { }
}

struct BooruPost: Codable, Identifiable, PostFormat {
    let file: String
    let preview: String
    let height: Int
    let width: Int
    let rating: Rating
    let tags: String
    let tagList: [String]
    let type: ImageType
    let id: String
    let image: String
    
    init<T: PostFormat>(post: T) {
        self.file = post.file
        self.preview = post.preview
        self.tags = post.tags
        self.tagList = post.getTags()
        self.height = post.height
        self.width = post.width
        self.rating = post.rating
        self.type = post.getType()
        self.id = post.id
        self.image = post.image
    }
}

struct BooruTag: Codable, Identifiable, TagFormat {
    let label: String
    let id: String
    
    init<T: TagFormat>(tag: T) {
        self.label = tag.label
        self.id = tag.id
    }
}
