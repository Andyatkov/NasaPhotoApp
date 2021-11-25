//
//  MainView.swift
//  ActorApp
//
//  Created by ADyatkov on 24.11.2021.
//

import SwiftUI

struct MainView: View {
    
    @ObservedObject var viewModel: MarsViewModel
    @State var typeLoading: Int = 0

    init(viewModel: MarsViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
            content
                .navigationTitle("NASA Photos ✨")
        }
    }
    
    private var content: some View {
        switch viewModel.state {
        case .start: return AnyView(startView)
        case .loading: return AnyView(laodingView)
        case .results: return AnyView(resultView)
        case .error: return AnyView(errorView)
        }
    }
}

private extension MainView {
    
    var startView: some View {
        VStack(spacing: 16.0) {
            Text("Choose one of the options")
            Picker("Choose one of the options", selection: $typeLoading) {
                Text("Combine").tag(TypeLoadingData.combine.rawValue)
                Text("Block").tag(TypeLoadingData.block.rawValue)
                Text("Async").tag(TypeLoadingData.async.rawValue)
            }
            .pickerStyle(.segmented)
            
            Spacer()
            Button("Load NASA Photos ✨") {
                switch typeLoading {
                case TypeLoadingData.combine.rawValue:
                    viewModel.loadMarsPhotos()
                case TypeLoadingData.block.rawValue:
                    viewModel.loadBlockMarsPhotos()
                case TypeLoadingData.async.rawValue:
                    viewModel.loadAsyncMarsPhotos()
                default:
                    break
                }
            }
            .padding(.bottom, 20.0)
        }
        .padding()
    }
    
    var laodingView: some View {
        ProgressView()
    }

    var resultView: some View {
        VStack {
            List {
                if viewModel.dataSource.isEmpty {
                    Text("No data")
                } else {
                    Section {
                        ForEach(viewModel.dataSource, content: DailyWeatherRow.init(viewModel:))
                    }
                    
                }
            }
            Button("Cancel") {
                viewModel.cancel()
            }
            .frame(width: 300.0, height: 40.0)
            .background(Color.blue.cornerRadius(12.0))
            .foregroundColor(Color.white)
            .padding()
        }
    }
    
    var errorView: some View {
        VStack(spacing: 16.0) {
            Text("⚠️ Sorry we cant loading data. Сan you try another way")
            Picker("Choose one of the options", selection: $typeLoading) {
                Text("Combine").tag(TypeLoadingData.combine.rawValue)
                Text("Block").tag(TypeLoadingData.block.rawValue)
                Text("Async").tag(TypeLoadingData.async.rawValue)
            }
            .pickerStyle(.segmented)
            
            Spacer()
            Button("Load NASA Photos ✨") {
                switch typeLoading {
                case TypeLoadingData.combine.rawValue:
                    viewModel.loadMarsPhotos()
                case TypeLoadingData.block.rawValue:
                    viewModel.loadBlockMarsPhotos()
                case TypeLoadingData.async.rawValue:
                    viewModel.loadAsyncMarsPhotos()
                default:
                    break
                }
            }
            .padding(.bottom, 20.0)
        }
        .padding()
    }
    
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(
            viewModel:
                MarsViewModel(
                    stateMachine: MainStateMachine(state: .start),
                    nasaFetchable: NasaFetcher(),
                    blockNasaFetchable: BlockNasaFetcher(),
                    asyncNasaFetchable: AsyncNasaFetcher()
                )
        )
    }
}
