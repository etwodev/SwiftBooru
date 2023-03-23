//
//  BookmarkManager.swift
//  SwiftBooru
//
//  Created by Ethan Woods on 18/03/2023.
//

import Foundation

struct BookmarkTag {
    let tag: String
    let count: Int
}

class BookmarkManager {
    private let FileManager: DictionaryFileManager<BooruPost>
    
    init(identifier: String) {
        FileManager = DictionaryFileManager<BooruPost>(identifier: identifier)
    }
    
    func getTags() -> [String : Int] {
        do {
            let posts = try FileManager.readDictionary() ?? [:]
            let counts = posts.values.reduce(into: [String:Int]()) { counts, post in
                for tag in post.tagList {
                    counts[tag, default: 0] += 1
                }
            }
            return counts
        } catch {
            return [:]
        }
    }
    
    func getPosts(tag: String) -> [BooruPost] {
        do {
            let posts = try FileManager.readDictionary() ?? [:]
            return Array(posts.filter({ $0.value.tags.contains(tag) }).values)
        } catch {
            return []
        }
    }

    func getMatchingPosts(tags: [String]) -> [BooruPost] {
        do {
            let posts = try FileManager.readDictionary() ?? [:]
            return Array(posts.filter({ tags.allSatisfy($0.value.tags.contains) }).values)
        } catch {
            return []
        }
    }
    
    func toggleBookmark<T: PostFormat>(post: T) -> Bool {
        do {
            var posts = try FileManager.readDictionary() ?? [:]
            if ((posts.contains(where: { $0.key == post.id }))) {
                posts.removeValue(forKey: post.id)
            } else {
                posts[post.id] = BooruPost(post: post)
            }
            try FileManager.writeDictionary(posts)
            return true
        } catch {
            return false
        }
    }
    
    func isBookmarked<T: PostFormat>(post: T) -> Bool {
        return FileManager.exists(BooruPost(post: post))
    }
}
