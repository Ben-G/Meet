//
//  MainStore.swift
//  Meet
//
//  Created by Benjamin Encz on 11/11/15.
//  Copyright © 2015 DigiTales. All rights reserved.
//

import Foundation
import ReactiveCocoa

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
    
    func unsubscribe(subscriber: StoreSubscriber) {
        // TODO: implement `unsubscribe`
//        if let index = subscribers.indexOf(subscriber) {
//            subscribers.removeAtIndex(index)
//        }
    }
    
    func dispatch(actionCreatorProvider: ActionCreatorProvider) -> Signal<AppState, NoError> {
        // dispatch this asynchronously to make sure that all receivers receive new state
        // before state is modified
        return Signal { observer in
            dispatch_async(dispatch_get_main_queue()) {
                let action = actionCreatorProvider()(state: self.appState, store: self)
                
                if let action = action {
                    self.appState = self.reducer.handleAction(self.appState, action: action)
                    observer.sendNext(self.appState)
                    observer.sendCompleted()
                }
            }
            
            return nil
        }
    }

}

protocol Store {
    var reducer: Reducer { get set }
    
    func subscribe(subscriber: StoreSubscriber)
    func dispatch(actionCreatorProvider: ActionCreatorProvider) -> Signal<AppState, NoError>
}

typealias ActionCreatorProvider = () -> ActionCreator
typealias ActionCreator = (state: AppState, store: MainStore) -> Action?

protocol StoreSubscriber {
    func newState(state: AppState)
}

protocol Reducer {
    func handleAction(state: AppState, action: Action) -> AppState
}