//
//  CacheManager.swift
//  SwiftBooru
//
//  Created by Ethan Woods on 18/03/2023.
//

import Foundation

class CacheManager {
    static let shared = CacheManager()
    private let cache = NSCache<NSString, CacheObject>()

    private init() {}

    func save<T: Codable>(_ object: T, forKey key: String, expiry: TimeInterval? = nil) {
        let encoder = JSONEncoder()
        guard let encodedObject = try? encoder.encode(object) else {
            return
        }
        let cacheObject = CacheObject(data: encodedObject, expiry: expiry)
        cache.setObject(cacheObject, forKey: key as NSString)
    }

    func getObject<T: Codable>(forKey key: String) -> T? {
        guard let cacheObject = cache.object(forKey: key as NSString) else {
            return nil
        }
        if let expiry = cacheObject.expiry, Date() > cacheObject.createdAt.addingTimeInterval(expiry) {
            cache.removeObject(forKey: key as NSString)
            return nil
        }
        let decoder = JSONDecoder()
        guard let object = try? decoder.decode(T.self, from: cacheObject.data) else {
            return nil
        }
        return object
    }

    func remove(forKey key: String) {
        cache.removeObject(forKey: key as NSString)
    }

    func removeAll() {
        cache.removeAllObjects()
    }

    private class CacheObject: NSObject {
        let data: Data
        let expiry: TimeInterval?
        let createdAt: Date

        init(data: Data, expiry: TimeInterval?) {
            self.data = data
            self.expiry = expiry
            self.createdAt = Date()
            super.init()
        }
    }
}
