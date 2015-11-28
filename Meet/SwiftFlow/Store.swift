//
//  Store.swift
//  Meet
//
//  Created by Benjamin Encz on 11/27/15.
//  Copyright © 2015 DigiTales. All rights reserved.
//

import Foundation
import ReactiveCocoa
import SwiftFlowReactiveCocoaExtensions

public class AnyStore<StateType: AppStateProtocol>: Store {
    private let box: _AnyStoreBoxBase<StateType>!
    public var reducer: AnyReducer<StateType>
    
    public init(reducer: AnyReducer<StateType>) {
        self.reducer = reducer
        self.box = nil
    }
    
    public typealias StoreActionCreator = (state: StateType, store: AnyStore<StateType>) -> ActionProtocol?
    public typealias StoreAsyncActionCreator = (state: StateType, store: AnyStore<StateType>) -> Signal<StoreActionCreator,NoError>?

    public typealias ActionCreatorProvider = () -> StoreActionCreator
    public typealias AsyncActionCreatorProvider = () -> StoreAsyncActionCreator
    
    public func dispatch(actionCreatorProvider: ActionCreatorProvider) -> Signal<StateType, NoError> {
        return box.dispatch(actionCreatorProvider)
    }
    
    public func dispatch(actionCreatorProvider: AsyncActionCreatorProvider) -> Signal<StateType, NoError> {
        return box.dispatch(actionCreatorProvider)
    }
    
    public func subscribe<S: StoreSubscriber where S.AppStateType == StateType>(subscriber: S) {
        box.subscribe(AnyStoreSubscriber(subscriber))
    }

}

class _AnyStoreBoxBase<State: AppStateProtocol>: Store {
    var reducer: AnyReducer<State>
    
    typealias StoreActionCreator = (state: State, store: AnyStore<State>) -> ActionProtocol?
    typealias StoreAsyncActionCreator = (state: State, store: AnyStore<State>) -> Signal<StoreActionCreator,NoError>?
    
    typealias ActionCreatorProvider = () -> StoreActionCreator
    typealias AsyncActionCreatorProvider = () -> StoreAsyncActionCreator
    
    
    init (reducer: AnyReducer<State>) {
        self.reducer = reducer
    }

    func subscribe(subscriber: AnyStoreSubscriber<State>) {
        fatalError()
    }
    
    func dispatch(actionCreatorProvider: AsyncActionCreatorProvider) -> Signal<State, NoError> {
        fatalError()
    }
    
    func dispatch(actionCreatorProvider: ActionCreatorProvider) -> Signal<State, NoError> {
        fatalError()
    }
}

class _AnyStoreBase<StoreType: Store>: _AnyStoreBoxBase<StoreType.StoreAppStateType> {
    
    let base: StoreType
    
    init(_ base: StoreType) {
        self.base = base
        
        super.init(reducer: base.reducer)
    }
    
    typealias StoreActionCreator = (state: StoreType.StoreAppStateType, store: AnyStore<StoreType.StoreAppStateType>) -> ActionProtocol?
    typealias StoreAsyncActionCreator = (state: StoreType.StoreAppStateType, store: AnyStore<StoreType.StoreAppStateType>) -> Signal<StoreActionCreator,NoError>?
    
    typealias ActionCreatorProvider = () -> StoreActionCreator
    typealias AsyncActionCreatorProvider = () -> StoreAsyncActionCreator
    
    override func subscribe(subscriber: AnyStoreSubscriber<StoreType.StoreAppStateType>) {
        base.subscribe(subscriber)
    }
    

    override func dispatch(actionCreatorProvider: ActionCreatorProvider) -> Signal<StoreType.StoreAppStateType, NoError> {
        return base.dispatch(actionCreatorProvider as! StoreType.ActionCreatorProvider)
    }
    
    override func dispatch(actionCreatorProvider: AsyncActionCreatorProvider) -> Signal<StoreType.StoreAppStateType, NoError> {
        return base.dispatch(actionCreatorProvider as! StoreType.AsyncActionCreatorProvider)
    }

}