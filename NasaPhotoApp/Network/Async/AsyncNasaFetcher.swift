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
    
    private let isMockState: Bool
    private let session: URLSession
    
    init(session: URLSession = .shared, isMockState: Bool = false) {
        self.session = session
        self.isMockState = isMockState
    }
    
    func marsPhotos() async throws -> MarsForecastResponse {
        guard !isMockState else { return MockData.shared.model }
        
        let components = NasaFetcher.marsPhotosComponents()
        guard let url = components.url else {
            throw NasaError.network(description: "Couldn't create URL")
        }
        
        let (data, _) = try await session.data(from: url)
        return try JSONDecoder().decode(MarsForecastResponse.self, from: data)
    }
}
