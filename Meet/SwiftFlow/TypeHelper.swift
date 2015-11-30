//
//  TypeHelper.swift
//  Meet
//
//  Created by Benjamin Encz on 11/27/15.
//  Copyright © 2015 DigiTales. All rights reserved.
//

import Foundation

public func withSpecificTypes<SpecificStateType, SpecificActionType: ActionType>(state: StateType, action: ActionType, @noescape function: (state: SpecificStateType, action: SpecificActionType) -> SpecificStateType) -> StateType {
    guard let a = action as? SpecificActionType else { return state }
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
    typealias ReducerActionType: ActionType
    typealias ReducerStateType

    func handleAction(state: ReducerStateType, action: ReducerActionType) -> ReducerStateType
}

extension Reducer {

    public func _handleAction(state: StateType, action: ActionType) -> StateType {
        return withSpecificTypes(state, action: action, function: handleAction)
    }

}