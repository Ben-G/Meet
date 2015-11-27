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

class MainStore<T: AppStateProtocol, A: ActionProtocol>: Store {
    
    typealias ActionCreator = (state: AppStateProtocol, store: MainStore) -> A?
    typealias AsyncActionCreator = (state: AppStateProtocol, store: MainStore) -> Signal<ActionCreator,NoError>?
    
    typealias ActionCreatorProvider = () -> ActionCreator
    typealias AsyncActionCreatorProvider = () -> AsyncActionCreator
    
    var appState = T() {
        didSet {
            subscribers.forEach { $0.newState(appState) }
        }
    }
    
    var reducer: AnyReducer<T, A>
    private var subscribers: [AnyStoreSubscriber<T>] = []
    
    init(reducer: AnyReducer<T, A>) {
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
//                    self.appState = self.reducer.handleAction(self.appState, action: action)
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
//                            self.appState = self.reducer.handleAction(self.appState, action: action)
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

public protocol Store {
    typealias StoreAppStateType: AppStateProtocol
    typealias StoreActionType: ActionProtocol
    typealias StoreActionCreator = (state: AppStateProtocol, store: Self) -> StoreActionType?
    typealias StoreAsyncActionCreator = (state: AppStateProtocol, store: Self) -> Signal<StoreActionCreator,NoError>?
    
    typealias ActionCreatorProvider = () -> StoreActionCreator
    typealias AsyncActionCreatorProvider = () -> StoreAsyncActionCreator
    
    var reducer: AnyReducer<StoreAppStateType, StoreActionType> { get set }
    
    func subscribe(subscriber: AnyStoreSubscriber<StoreAppStateType>)
    func dispatch(actionCreatorProvider: AsyncActionCreatorProvider) -> Signal<StoreAppStateType, NoError>
    
    func dispatch(actionCreatorProvider: ActionCreatorProvider) -> Signal<StoreAppStateType, NoError>
}

public protocol AppStateProtocol {
    init()
}

public protocol Reducer {
    typealias StateType: AppStateProtocol
    typealias ActionType: ActionProtocol
    
    func handleAction(state: StateType, action: ActionType) -> StateType
}

public final class AnyReducer<StateType: AppStateProtocol, ActionType: ActionProtocol>: Reducer {
    let reducer: _ReducerBoxBase<StateType, ActionType>
    
    init<T: Reducer where T.StateType == StateType, T.ActionType == ActionType>(_ reducer: T) {
        self.reducer = _ReducerBox(reducer)
    }
    
    public func handleAction(state: StateType, action: ActionType) -> StateType {
        return reducer.handleAction(state, action: action)
    }
}

class _ReducerBox<ReducerType: Reducer>: _ReducerBoxBase<ReducerType.StateType, ReducerType.ActionType> {
    let base: ReducerType
    
    init(_ base: ReducerType) {
        self.base = base
    }
    
    override func handleAction(state: ReducerType.StateType, action: ReducerType.ActionType) -> ReducerType.StateType {
        return base.handleAction(state, action: action)
    }
}

class _ReducerBoxBase<StateType: AppStateProtocol, ActionType: ActionProtocol>: Reducer {
    func handleAction(state: StateType, action: ActionType) -> StateType {
        fatalError()
    }
}