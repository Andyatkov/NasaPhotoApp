//
//  MarsRowViewModel.swift
//  ActorApp
//
//  Created by ADyatkov on 24.11.2021.
//

import Foundation
import SwiftUI

struct MarsRowViewModel: Identifiable {
    
    private let item: MarsForecastResponse.Photo
    
    var id: String {
        return String(item.id)
    }
    
    var imageURL: String {
        return item.imgageURL
    }
    
    var earthDate: String {
        return item.earthDate
    }
    
    
    init(item: MarsForecastResponse.Photo) {
        self.item = item
    }
}

extension MarsRowViewModel: Hashable {
    
    static func == (lhs: MarsRowViewModel, rhs: MarsRowViewModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
}

