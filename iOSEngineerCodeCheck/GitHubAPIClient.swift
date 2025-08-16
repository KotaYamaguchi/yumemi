//
//  GitHubAPIClient.swift
//  iOSEngineerCodeCheck
//
//  Created by Kota Yamaguchi on 2025/08/15.
//  Copyright © 2025 YUMEMI Inc. All rights reserved.
//

import Foundation

// API通信時に発生しうるエラーを定義
enum APIError: Error {
    case invalidURL
    case networkError(Error)
    case decodingError(Error)
    case noData
}

struct GitHubAPIClient {
    
    func searchRepositories(query: String, completion: @escaping (Result<[Repository], APIError>) -> Void) {
        guard let url = URL(string: "https://api.github.com/search/repositories?q=\(query)") else {
            completion(.failure(.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(.networkError(error)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let searchResponse = try decoder.decode(SearchResponse.self, from: data)
                // UI更新はメインスレッドで行うため、ここで切り替える
                DispatchQueue.main.async {
                    completion(.success(searchResponse.items))
                }
            } catch let decodingError {
                DispatchQueue.main.async {
                    completion(.failure(.decodingError(decodingError)))
                }
            }
        }
        task.resume()
    }
}
