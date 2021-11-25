//
//  AsyncNasaFetcher.swift
//  ActorApp
//
//  Created by ADyatkov on 25.11.2021.
//

import Foundation

protocol AsyncNasaFetchable {
    func marsPhotos() async throws -> MarsForecastResponse
}

struct AsyncNasaFetcher: AsyncNasaFetchable {
    
    func marsPhotos() async throws -> MarsForecastResponse {
        let components = NasaFetcher.marsPhotosComponents()
        guard let url = components.url else {
            throw NasaError.network(description: "Couldn't create URL")
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(MarsForecastResponse.self, from: data)
    }
}
