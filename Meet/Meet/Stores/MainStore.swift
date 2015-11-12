//
//  MainStore.swift
//  Meet
//
//  Created by Benjamin Encz on 11/11/15.
//  Copyright © 2015 DigiTales. All rights reserved.
//

import Foundation

class MainStore: Store {
    
    var appState = AppState() {
        didSet {
            subscribers.forEach { $0.newState(appState) }
        }
    }
    
    var reducer: Reducer = MainReducer()
    
    private var subscribers: [StoreSubscriber] = []
    
    func subscribe(subscriber: StoreSubscriber) {
        subscribers.append(subscriber)
        subscriber.newState(appState)
    }
    
    func dispatch(actionCreatorProvider: ActionCreatorProvider) {
        let action = actionCreatorProvider()(state: appState, store: self)
        
        if let action = action {
            appState = reducer.handleAction(appState, action: action)
        }
    }

}

protocol Store {
    var reducer: Reducer { get set }
    
    func subscribe(subscriber: StoreSubscriber)
    func dispatch(actionCreatorProvider: ActionCreatorProvider)
}

typealias ActionCreatorProvider = () -> ActionCreator
typealias ActionCreator = (state: AppState, store: MainStore) -> Action?

protocol StoreSubscriber {
    func newState(state: AppState)
}

protocol Reducer {
    func handleAction(state: AppState, action: Action) -> AppState
}

