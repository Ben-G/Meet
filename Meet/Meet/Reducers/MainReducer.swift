//
//  MainReducer.swift
//  Meet
//
//  Created by Benjamin Encz on 11/11/15.
//  Copyright © 2015 DigiTales. All rights reserved.
//

import Foundation
import SwiftFlowReactiveCocoaExtensions
import SwiftFlow
import SwiftFlowRouter

struct MainReducer: Reducer {
    
    var reducers: [Reducer] = [NavigationReducer(), DataMutationReducer(), TwitterAPIReducer()]
    
    func handleAction(var state: AppStateProtocol, action: ActionProtocol) -> AppStateProtocol {
        reducers.forEach { reducer in
            state = reducer.handleAction(state, action: action)
        }
        
        return state
    }
    
}