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

public class MainStore<T: AppStateProtocol>: Store {
    
    public typealias ActionCreator = (state: AppStateProtocol, store: MainStore) -> ActionProtocol?
    public typealias AsyncActionCreator = (state: AppStateProtocol, store: MainStore) -> Signal<ActionCreator,NoError>?
    
    public typealias ActionCreatorProvider = () -> ActionCreator
    public typealias AsyncActionCreatorProvider = () -> AsyncActionCreator
    
    var appState = T() {
        didSet {
            subscribers.forEach { $0.newState(appState) }
        }
    }
    
    public var reducer: AnyReducer<T>
    private var subscribers: [AnyStoreSubscriber<T>] = []
    
    public init(reducer: AnyReducer<T>) {
        self.reducer = reducer
    }
    
    public func subscribe(subscriber: AnyStoreSubscriber<T>) {
        subscribers.append(subscriber)
        subscriber.newState(appState)
    }
    
    func unsubscribe(subscriber: AnyStoreSubscriber<T>) {
        // TODO: implement `unsubscribe`
        //        if let index = subscribers.indexOf(subscriber) {
        //            subscribers.removeAtIndex(index)
        //        }
    }
    
    public func dispatch(actionCreatorProvider: ActionCreatorProvider) -> Signal<T, NoError> {
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
    
    
    public func dispatch(actionCreatorProvider: AsyncActionCreatorProvider) -> Signal<T, NoError> {
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
    typealias StoreActionCreator = (state: AppStateProtocol, store: Self) -> ActionProtocol?
    typealias StoreAsyncActionCreator = (state: AppStateProtocol, store: Self) -> Signal<StoreActionCreator,NoError>?
    
    typealias ActionCreatorProvider = () -> StoreActionCreator
    typealias AsyncActionCreatorProvider = () -> StoreAsyncActionCreator
    
    var reducer: AnyReducer<StoreAppStateType> { get set }
    
    func subscribe(subscriber: AnyStoreSubscriber<StoreAppStateType>)
    func dispatch(actionCreatorProvider: AsyncActionCreatorProvider) -> Signal<StoreAppStateType, NoError>
    
    func dispatch(actionCreatorProvider: ActionCreatorProvider) -> Signal<StoreAppStateType, NoError>
}

//public protocol AnyStore {
//    
//    func dispatch(actionCreatorProvider: AsyncActionCreatorProvider) -> Signal<StoreAppStateType, NoError>
//    func dispatch(actionCreatorProvider: ActionCreatorProvider) -> Signal<StoreAppStateType, NoError>
//
//}

public protocol AppStateProtocol {
    init()
}

public protocol Reducer {
    typealias StateType: AppStateProtocol
    
    func handleAction(state: StateType, action: ActionProtocol) -> StateType
}

public final class AnyReducer<StateType: AppStateProtocol>: Reducer {
    let reducer: _ReducerBoxBase<StateType>
    
    public init<T: Reducer where T.StateType == StateType>(_ reducer: T) {
        self.reducer = _ReducerBox(reducer)
    }
    
    public func handleAction(state: StateType, action: ActionProtocol) -> StateType {
        return reducer.handleAction(state, action: action)
    }
}

public class _ReducerBox<ReducerType: Reducer>: _ReducerBoxBase<ReducerType.StateType> {
    let base: ReducerType
    
    public init(_ base: ReducerType) {
        self.base = base
    }
    
    override func handleAction(state: ReducerType.StateType, action: ActionProtocol) -> ReducerType.StateType {
        return base.handleAction(state, action: action)
    }
}

class _ReducerBoxBase<StateType: AppStateProtocol>: Reducer {
    func handleAction(state: StateType, action: ActionProtocol) -> StateType {
        fatalError()
    }
}