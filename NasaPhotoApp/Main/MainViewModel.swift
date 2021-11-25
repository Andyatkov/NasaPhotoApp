//
//  MainViewModel.swift
//  ActorApp
//
//  Created by ADyatkov on 24.11.2021.
//

import SwiftUI
import Combine

class MarsViewModel: ObservableObject {
    
   
    @Published private(set) var state: MainStateMachine.State
    
    private(set) var dataSource: [MarsRowViewModel] = []
    
    private let stateMachine: MainStateMachine
    private let nasaFetcher: NasaFetchable
    private let blockNasaFetchable: BlockNasaFetchable
    private let asyncNasaFetchable: AsyncNasaFetchable
    private var asyncTask: Task<(), Never>?
    private var disposables = Set<AnyCancellable>()
    private var stateCancellable: AnyCancellable?
    
    init(
        stateMachine: MainStateMachine,
        nasaFetchable: NasaFetchable,
        blockNasaFetchable: BlockNasaFetchable,
        asyncNasaFetchable: AsyncNasaFetchable) {
            
            self.stateMachine = stateMachine
            self.state = stateMachine.state
            self.nasaFetcher = nasaFetchable
            self.blockNasaFetchable = blockNasaFetchable
            self.asyncNasaFetchable = asyncNasaFetchable
            self.stateCancellable = stateMachine.statePublisher.sink { state in
                DispatchQueue.main.async {
                    self.state = state
                }
            }
    }
    
    func cancel() {
        stateMachine.tryEvent(.cancel)
    }
    
    func loadMarsPhotos() {
        stateMachine.tryEvent(.loadingCombine)
        nasaFetcher.marsPhotos()
            .map { response in
                response.photos.map(MarsRowViewModel.init)
            }
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] value in
                    guard let self = self else { return }
                    switch value {
                    case .failure:
                        self.dataSource = []
                        self.stateMachine.tryEvent(.failure)
                    case .finished:
                        break
                    }
                },
                receiveValue: { [weak self] forecast in
                    guard let self = self else { return }
                    self.dataSource = forecast
                    self.stateMachine.tryEvent(.success)
                })
            .store(in: &disposables)
    }
    
    func loadBlockMarsPhotos() {
        stateMachine.tryEvent(.loadingBlock)
        blockNasaFetchable.marsPhotos { [weak self] result in
            switch result {
            case .success(let responce):
                guard let self = self else { return }
                
                DispatchQueue.main.async {
                    self.dataSource = responce.photos.map(MarsRowViewModel.init)
                    self.stateMachine.tryEvent(.success)
                }
            case .failure(_):
                self?.stateMachine.tryEvent(.failure)
            }
        }
    }
    
    func loadAsyncMarsPhotos() {
        stateMachine.tryEvent(.loadingAsync)
        asyncTask?.cancel()
        asyncTask = Task {
            do {
                let responce = try await fetchAsyncMarsPhotos()
                DispatchQueue.main.async {
                    self.dataSource = responce
                    self.stateMachine.tryEvent(.success)
                }
            } catch {
                print("Request failed with error: \(error)")
                self.stateMachine.tryEvent(.failure)
            }
        }
    }
    
    private func fetchAsyncMarsPhotos()  async throws -> [MarsRowViewModel] {
        return try await asyncNasaFetchable.marsPhotos().photos.map(MarsRowViewModel.init)
    }
    
}
