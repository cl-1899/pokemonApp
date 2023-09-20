//
//  ApiClient.swift
//  pokemonApp
//
//  Created by Andrei Martynenka on 19.09.23.
//

import Foundation

class ApiClient {
    static func fetchData(with url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error {
                completion(.failure(error))
                return
            }
            
            guard let data else {
                completion(.failure(NSError(domain: "An Error occured while loading data.", code: 0)))
                return
            }
            
            completion(.success(data))
        }.resume()
    }
}

