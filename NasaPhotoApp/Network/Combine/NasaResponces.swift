//
//  NasaResponces.swift
//  ActorApp
//
//  Created by ADyatkov on 24.11.2021.
//

import Foundation

struct MarsForecastResponse: Decodable {
  let photos: [Photo]
  
  struct Photo: Codable {
    let id: Int
    let sol: Int
    let imgageURL: String
    let earthDate: String
    
    enum CodingKeys: String, CodingKey {
      case id
      case sol
      case imgageURL = "img_src"
      case earthDate = "earth_date"
    }
  }
}
