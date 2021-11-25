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
    
    private let isMockState: Bool
    private let session: URLSession
    
    init(session: URLSession = .shared, isMockState: Bool = false) {
        self.session = session
        self.isMockState = isMockState
    }
    
    func marsPhotos(completion: @escaping (Result<MarsForecastResponse, NasaError>) -> Void) {
        guard !isMockState else { return completion(.success(MockData.shared.model)) }
        
        let components = NasaFetcher.marsPhotosComponents()
        guard let url = components.url else {
            let error = NasaError.network(description: "Couldn't create URL")
            completion(.failure(error))
            return
        }

        session.dataTask(with: url) { data, _, error in

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
