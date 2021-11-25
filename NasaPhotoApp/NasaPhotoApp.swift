//
//  NasaPhotoApp.swift
//  NasaPhotoApp
//
//  Created by ADyatkov on 25.11.2021.
//

import SwiftUI

@main
struct NasaPhotoApp: App {
    
    let isMockState = false
    let marsViewModel: MarsViewModel
    
    init() {
        MockData.shared.setModel()
        let fetcher = NasaFetcher(isMockState: isMockState)
        let blockNasaFetchable = BlockNasaFetcher(isMockState: isMockState)
        let asyncNasaFetchable = AsyncNasaFetcher(isMockState: isMockState)
        let stateMachine = MainStateMachine(state: .start)
        marsViewModel = MarsViewModel(stateMachine: stateMachine, nasaFetchable: fetcher, blockNasaFetchable: blockNasaFetchable, asyncNasaFetchable: asyncNasaFetchable)
    }
    
    var body: some Scene {
        WindowGroup {
            MainView(viewModel: marsViewModel)
        }
    }
}
