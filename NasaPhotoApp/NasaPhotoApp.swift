//
//  NasaPhotoApp.swift
//  NasaPhotoApp
//
//  Created by ADyatkov on 25.11.2021.
//

import SwiftUI

@main
struct NasaPhotoApp: App {
    
    let marsViewModel: MarsViewModel
    
    init() {
        let fetcher = NasaFetcher()
        let blockNasaFetchable = BlockNasaFetcher()
        let asyncNasaFetchable = AsyncNasaFetcher()
        let stateMachine = MainStateMachine(state: .start)
        marsViewModel = MarsViewModel(stateMachine: stateMachine, nasaFetchable: fetcher, blockNasaFetchable: blockNasaFetchable, asyncNasaFetchable: asyncNasaFetchable)
    }
    
    var body: some Scene {
        WindowGroup {
            MainView(viewModel: marsViewModel)
        }
    }
}
