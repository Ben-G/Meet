//
//  MainReducer.swift
//  Meet
//
//  Created by Benjamin Encz on 11/11/15.
//  Copyright © 2015 DigiTales. All rights reserved.
//

import Foundation

public struct MainReducer: Reducer {
    
    var reducers: [Reducer]
    
    public init(_ reducers: [Reducer]) {
        self.reducers = reducers
    }
    
    public func handleAction(var state: AppStateProtocol, action: ActionProtocol) -> AppStateProtocol {
        reducers.forEach { reducer in
            state = reducer.handleAction(state, action: action)
        }
        
        return state
    }
    
}