//
//  NetworkManager.swift
//  TestApp
//
//  Created by Paul Matar on 27/05/2022.
//

import Foundation

extension NetworkManager {
    
    enum APIUrls {
        static fileprivate let someURL = "https://fakestoreapi.com/products"
    }
    
    enum NetworkError: Error {
        case invalidURL
        case invalidData
        case invalidStatusCode(Int)
        case unableToComplete
        case invalidResponse
        case unableToDecode
    }
}

final class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {}
    
    func fetchProducts(completion: @escaping (Result<[Product], NetworkError>) -> Void) {
        guard let url = URL(string: APIUrls.someURL) else {
            completion(.failure(.invalidURL))
            return
        }
        
        let task = URLSession.shared
        
        task.dataTask(with: url) { data, response, error in
            guard error == nil else {
                completion(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard (200..<300).contains(response.statusCode) else {
                completion(.failure(.invalidStatusCode(response.statusCode)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            do {

                let products = try JSONDecoder().decode([Product].self, from: data)
                completion(.success(products))
            } catch {
                print("unable to decode")
                completion(.failure(.unableToDecode))
            }
        }.resume()
        
    }
    
}
