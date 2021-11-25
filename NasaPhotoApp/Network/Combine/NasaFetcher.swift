//
//  NasaFetcher.swift
//  ActorApp
//
//  Created by ADyatkov on 24.11.2021.
//

import Foundation
import Combine

protocol NasaFetchable {
    func marsPhotos() -> AnyPublisher<MarsForecastResponse, NasaError>
}


class NasaFetcher {
    
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
}

extension NasaFetcher: NasaFetchable {
    
    func marsPhotos() -> AnyPublisher<MarsForecastResponse, NasaError> {
        return forecast(with: NasaFetcher.marsPhotosComponents())
    }
    
    private func forecast<T>(
        with components: URLComponents
    ) -> AnyPublisher<T, NasaError> where T: Decodable {
        guard let url = components.url else {
            let error = NasaError.network(description: "Couldn't create URL")
            return Fail(error: error).eraseToAnyPublisher()
        }
        return session.dataTaskPublisher(for: URLRequest(url: url))
            .mapError { error in
                .network(description: error.localizedDescription)
            }
            .flatMap(maxPublishers: .max(1)) { pair in
                decode(pair.data)
            }
            .eraseToAnyPublisher()
    }
    
}

extension NasaFetcher {
    
    enum NasaAPI {
        static let scheme = "https"
        static let host = "api.nasa.gov"
        static let pathMars = "/mars-photos/api/v1/rovers/curiosity/photos"
        static let key = "<NASA API KEY>"
    }
    
    static func marsPhotosComponents(count: Int = 1000) -> URLComponents {
        var components = URLComponents()
        components.scheme = NasaAPI.scheme
        components.host = NasaAPI.host
        components.path = NasaAPI.pathMars
        
        components.queryItems = [
            URLQueryItem(name: "sol", value: "\(count)"),
            URLQueryItem(name: "api_key", value: NasaAPI.key)
        ]
        
        return components
    }
}
