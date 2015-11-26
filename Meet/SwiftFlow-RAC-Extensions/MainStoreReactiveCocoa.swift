//
//  MainStoreReactiveCocoa.swift
//  Meet
//
//  Created by Benjamin Encz on 11/26/15.
//  Copyright © 2015 DigiTales. All rights reserved.
//

import Foundation
import ReactiveCocoa
import SwiftFlow

class MainStore<T: AppStateProtocol>: Store {
    
    var appState = T() {
        didSet {
            subscribers.forEach { $0.newState(appState) }
        }
    }
    
    var reducer: Reducer
    private var subscribers: [AnyStoreSubscriber<T>] = []
    
    init(reducer: Reducer) {
        self.reducer = reducer
    }
    
    func subscribe(subscriber: AnyStoreSubscriber<T>) {
        subscribers.append(subscriber)
        subscriber.newState(appState)
    }
    
    func unsubscribe(subscriber: AnyStoreSubscriber<T>) {
        // TODO: implement `unsubscribe`
        //        if let index = subscribers.indexOf(subscriber) {
        //            subscribers.removeAtIndex(index)
        //        }
    }
    
    func dispatch(actionCreatorProvider: ActionCreatorProvider) -> Signal<T, NoError> {
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
    
    
    func dispatch(actionCreatorProvider: AsyncActionCreatorProvider) -> Signal<T, NoError> {
        // dispatch this asynchronously to make sure that all receivers receive new state
        // before state is modified
        return Signal { observer in
            dispatch_async(dispatch_get_main_queue()) {
                let actionProviderSignal = actionCreatorProvider()(state: self.appState, store: self)
                
                if let actionProviderSignal = actionProviderSignal {
                    actionProviderSignal.observeNext { actionProvider in
                        let action = actionProvider(state: self.appState, store: self)
                        if let action = action {
                            self.appState = self.reducer.handleAction(self.appState, action: action)
                            observer.sendNext(self.appState)
                            observer.sendCompleted()
                        }
                    }
                }
            }
            
            return nil
        }
    }
    
}

protocol Store {
    typealias AppStateType: AppStateProtocol
    
    var reducer: Reducer { get set }
    
    func subscribe(subscriber: AnyStoreSubscriber<AppStateType>)
    func dispatch(actionCreatorProvider: AsyncActionCreatorProvider) -> Signal<AppStateType, NoError>
    
    func dispatch(actionCreatorProvider: ActionCreatorProvider) -> Signal<AppStateType, NoError>
}

struct ActionCreatorTHing<U> {
    func test<T: Store where T.AppStateType == U>(state: U, store: T) -> ActionProtocol? {
    
    }
}

func doSomething<T>(t: T) {
    
}

typealias ActionCreator = (state: AppStateProtocol, store: Store) -> ActionProtocol?
typealias AsyncActionCreator = (state: AppStateProtocol, store: Store) -> Signal<ActionCreator,NoError>?

typealias ActionCreatorProvider = () -> ActionCreator
typealias AsyncActionCreatorProvider = () -> AsyncActionCreator



protocol AppStateProtocol {
    init()
}

protocol StoreSubscriber {
    typealias AppStateType
    
    func newState(state: AppStateType)
}

protocol Reducer {
    func handleAction(state: AppStateProtocol, action: ActionProtocol) -> AppStateProtocol
}

final class AnyStoreSubscriber<SubscriberType>: StoreSubscriber {
    let subscriber: _AnySubscriberBoxBase<SubscriberType>
    
    init<T: StoreSubscriber where T.AppStateType == SubscriberType>(_ subscriber: T) {
        self.subscriber = _AnySubscriberBox(subscriber)
    }
    
    func newState(state: SubscriberType) {
        subscriber.newState(state)
    }
}

class _AnySubscriberBoxBase<T>: StoreSubscriber {
    func newState(state: T) {
        fatalError()
    }
}

class _AnySubscriberBox<SubscriberType: StoreSubscriber>: _AnySubscriberBoxBase<SubscriberType.AppStateType> {
    let base: SubscriberType
    
    init(_ base: SubscriberType) {
        self.base = base
    }
    
    override func newState(state: SubscriberType.AppStateType) {
        base.newState(state)
    }
}