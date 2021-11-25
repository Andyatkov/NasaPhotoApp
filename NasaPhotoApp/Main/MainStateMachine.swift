//
//  MainStateMachine.swift
//  ActorApp
//
//  Created by ADyatkov on 25.11.2021.
//

import Combine
import Foundation

class MainStateMachine {
    
    enum State {
        case start
        case loading
        case results
        case error
    }
    
    enum Event {
        case loadingCombine
        case loadingBlock
        case loadingAsync
        case success
        case failure
        case cancel
    }
    
    private var typeLoading: TypeLoadingData = .combine
    private var startTime: DispatchTime?
    private var endTime: DispatchTime?

    private(set) var state: State {
        didSet { stateSubject.send(self.state) }
    }
    private let stateSubject: PassthroughSubject<State, Never>
    let statePublisher: AnyPublisher<State, Never>
    
    init(state: State) {
        self.state = state
        self.stateSubject = PassthroughSubject<State, Never>()
        self.statePublisher = self.stateSubject.eraseToAnyPublisher()
    }
    
}

// MARK: - State changes

extension MainStateMachine {
    
    @discardableResult func tryEvent(_ event: Event) -> Bool {
        guard let state = nextState(for: event) else {
            return false
        }
        
        self.state = state
        return true
    }
    
    private func nextState(for event: Event) -> State? {
        switch state {
        case .start:
            switch event {
            case .loadingCombine, .loadingBlock, .loadingAsync:
                detectStartTime(event: event)
                return .loading
            case .success, .failure, .cancel:
                return nil
            }
        case .loading:
            switch event {
            case .loadingCombine, .loadingBlock, .loadingAsync:
                return nil
            case .success:
                detectEndTime()
                return .results
            case .failure:
                return .error
            case .cancel:
                return .start
            }
        case .results:
            switch event {
            case .cancel:
                return .start
            default:
                return nil
            }
        case .error:
            switch event {
            case .loadingCombine, .loadingBlock, .loadingAsync:
                return .loading
            case .success, .failure, .cancel:
                return nil
            }
        }
    }
    
    private func detectStartTime(event: Event) {
        startTime = nil
        endTime = nil
        
        switch event {
        case .loadingCombine:
            self.typeLoading = .combine
        case .loadingAsync:
            self.typeLoading = .async
        case .loadingBlock:
            self.typeLoading = .block
        default:
            break
        }
        startTime = DispatchTime.now()
    }
    
    private func detectEndTime() {
        endTime = DispatchTime.now()
        checkTime()
    }
    
    private func checkTime() {
        guard let startTime = startTime, let endTime = endTime else { return }
        
        let nanoTime = endTime.uptimeNanoseconds - startTime.uptimeNanoseconds
        let timeInterval = Double(nanoTime) / 1_000_000_000
        
        print("Time by type loading \(typeLoading.rawValue): \(timeInterval) seconds")
    }
    
}

