//
//  BlockNasaFetcher.swift
//  ActorApp
//
//  Created by ADyatkov on 25.11.2021.
//

import Foundation

protocol BlockNasaFetchable {
    func marsPhotos(completion: @escaping (Result<MarsForecastResponse, NasaError>) -> Void)
}

struct BlockNasaFetcher: BlockNasaFetchable {
    
    func marsPhotos(completion: @escaping (Result<MarsForecastResponse, NasaError>) -> Void) {
        let components = NasaFetcher.marsPhotosComponents()
        guard let url = components.url else {
            let error = NasaError.network(description: "Couldn't create URL")
            completion(.failure(error))
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in

            if let error = error {
                completion(.failure(.network(description: error.localizedDescription)))
                return
            }

            guard let data = data else {
                completion(.failure(.network(description: "Missing data")))
                return
            }

            do {
                let result = try JSONDecoder().decode(MarsForecastResponse.self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(.network(description: error.localizedDescription)))
            }

        }.resume()
    }
}
