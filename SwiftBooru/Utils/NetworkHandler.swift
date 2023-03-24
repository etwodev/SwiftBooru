//
//  NetworkHandler.swift
//  SwiftBooru
//
//  Created by Ethan Woods on 18/03/2023.
//

import Foundation

func fetchJSON<T: Decodable>(url: URL, completion: @escaping (Result<T, Error>) -> Void) {
    URLSession.shared.dataTask(with: url) { data, response, error in
        guard let data = data, error == nil else {
            completion(.failure(error ?? NSError(domain: "Unknown error", code: -1, userInfo: nil)))
            return
        }
        do {
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            completion(.success(decodedData))
        } catch {
            completion(.failure(error))
        }
    }.resume()
}
