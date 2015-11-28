//
//  TypeHelper.swift
//  Meet
//
//  Created by Benjamin Encz on 11/27/15.
//  Copyright © 2015 DigiTales. All rights reserved.
//

import Foundation

public func withSpecificTypes<StateType, ActionType: ActionProtocol>(state: AppStateProtocol, action: ActionProtocol, @noescape function: (state: StateType, action: ActionType) -> StateType) -> AppStateProtocol {
    guard let a = action as? ActionType else { return state }
    guard let s = state as? StateType else { return state }
    
    return function(state: s, action: a) as! AppStateProtocol
}

public protocol TypedReducer: Reducer {
    typealias ActionType: ActionProtocol
    typealias StateType
    
    func handleTypedAction(state: StateType, action: ActionType) -> StateType
}

extension TypedReducer {
    
    public func handleAction(state: AppStateProtocol, action: ActionProtocol) -> AppStateProtocol {
        return withSpecificTypes(state, action: action, function: handleTypedAction)
    }
    
}