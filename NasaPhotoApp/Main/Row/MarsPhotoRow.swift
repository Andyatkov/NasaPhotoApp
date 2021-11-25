//
//  MarsPhotoRow.swift
//  ActorApp
//
//  Created by ADyatkov on 24.11.2021.
//

import SwiftUI

struct DailyWeatherRow: View {
    
    private let viewModel: MarsRowViewModel
    
    init(viewModel: MarsRowViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        HStack {
            if #available(iOS 15, *) {
                AsyncImage(url: URL(string: viewModel.imageURL))
                    .frame(width: 72.0, height: 72.0)
                    .clipped()
            } else {
                ImageURLView(withURL: viewModel.imageURL, size: CGSize(width: 72.0, height: 72.0))
            }
            VStack {
                Text("\(viewModel.id)")
                Text("\(viewModel.earthDate)")
            }
            Spacer()
        }
    }
}

