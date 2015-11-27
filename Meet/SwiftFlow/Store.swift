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



class _AnyStoreBoxBase<State: AppStateProtocol, Action: ActionProtocol, ActionCreatorProviderType, AsyncActionCreatorProviderType>: Store {
    var reducer: AnyReducer<State, Action>
    
    init (reducer: AnyReducer<State, Action>) {
        self.reducer = reducer
    }

    func subscribe(subscriber: AnyStoreSubscriber<State>) {
        fatalError()
    }
    
    func dispatch(actionCreatorProvider: AsyncActionCreatorProviderType) -> Signal<State, NoError> {
        fatalError()
    }
    
    func dispatch(actionCreatorProvider: ActionCreatorProviderType) -> Signal<State, NoError> {
        fatalError()
    }
}

class _AnyStoreBase<StoreType: Store>: _AnyStoreBoxBase<StoreType.StoreAppStateType, StoreType.StoreActionType, StoreType.ActionCreatorProvider, StoreType.AsyncActionCreatorProvider> {
    
    let base: StoreType
    
    init(_ base: StoreType) {
        self.base = base
        
        super.init(reducer: base.reducer)
    }
    
    override func subscribe(subscriber: AnyStoreSubscriber<StoreType.StoreAppStateType>) {
        base.subscribe(subscriber)
    }

    override func dispatch(actionCreatorProvider: StoreType.ActionCreatorProvider) -> Signal<StoreType.StoreAppStateType, NoError> {
        return base.dispatch(actionCreatorProvider)
    }

}



//class _AnySubscriberBox<SubscriberType: StoreSubscriber>: _AnySubscriberBoxBase<SubscriberType.AppStateType> {
//    let base: SubscriberType
//    
//    init(_ base: SubscriberType) {
//        self.base = base
//    }
//    
//    override func newState(state: SubscriberType.AppStateType) {
//        base.newState(state)
//    }
//}




//class _AnySubscriberBoxBase<T>: StoreSubscriber {
//    func newState(state: T) {
//        fatalError()
//    }
//}