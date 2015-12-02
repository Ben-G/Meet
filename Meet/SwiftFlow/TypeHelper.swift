//
//  TypeHelper.swift
//  Meet
//
//  Created by Benjamin Encz on 11/27/15.
//  Copyright © 2015 DigiTales. All rights reserved.
//

import Foundation

public func withSpecificTypes<SpecificStateType, Action>(state: StateType,
    action: Action, @noescape function: (state: SpecificStateType, action: Action)
    -> SpecificStateType) -> StateType {
//TODO: Replace specific action type with specific action payload type
    guard let a = action as? Action else { return state }
    guard let s = state as? SpecificStateType else { return state }

    return function(state: s, action: a) as! StateType
}

public protocol StoreSubscriber: AnyStoreSubscriber {
    typealias StoreSubscriberStateType

    func newState(state: StoreSubscriberStateType)

}

extension StoreSubscriber {
    public func _newState(state: StateType) {
        if let typedState = state as? StoreSubscriberStateType {
            newState(typedState)
        }
    }
}

public protocol Reducer: AnyReducer {
    typealias ReducerStateType

    func handleAction(state: ReducerStateType, action: Action) -> ReducerStateType
}

extension Reducer {

    public func _handleAction(state: StateType, action: Action) -> StateType {
        return withSpecificTypes(state, action: action, function: handleAction)
    }

}
