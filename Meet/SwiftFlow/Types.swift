//
//  Types.swift
//  Meet
//
//  Created by Benjamin Encz on 11/27/15.
//  Copyright © 2015 DigiTales. All rights reserved.
//

import Foundation

public protocol ActionType {}

public protocol StateType {
    init()
}

public protocol SubStateType {}

public protocol AnyStoreSubscriber: class {
    func _newState(state: StateType)
}

public protocol AnyReducer {
    func _handleAction(state: StateType, action: ActionType) -> StateType
}
