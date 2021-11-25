//
//  NasaNetworkManager.swift
//  ActorApp
//
//  Created by ADyatkov on 24.11.2021.
//

import Foundation

enum NasaError: Error {
  case parsing(description: String)
  case network(description: String)
}
