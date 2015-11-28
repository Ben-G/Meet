//
//  TwitterAPIReducer.swift
//  Meet
//
//  Created by Benjamin Encz on 11/20/15.
//  Copyright © 2015 DigiTales. All rights reserved.
//

import Foundation
import SwifteriOS
import SwiftFlow
import SwiftFlowReactiveCocoaExtensions

struct TwitterAPIReducer: Reducer {
    
    func handleAction(state: AppStateProtocol, action: ActionProtocol) -> AppStateProtocol {
        guard let s = state as? HasTwitterAPIState else { return  state }
        guard let a = action as? TwitterAPIAction else { return state }
        
        switch a {
        case .SetTwitterClient(let swifter):
            return setTwitterClient(s, swifter: swifter) as! AppStateProtocol
        case .SetUserSearchResults(let users):
            return setUserSearchResults(s, userSearchResults: users) as! AppStateProtocol
        }
    }
    
    func setTwitterClient(var state: HasTwitterAPIState, swifter: Swifter) -> HasTwitterAPIState {
        state.twitterAPIState.swifter = swifter
        
        return state
    }
    
    func setUserSearchResults(var state: HasTwitterAPIState, userSearchResults: [TwitterUser]) -> HasTwitterAPIState {
        state.twitterAPIState.userSearchResults = userSearchResults
        
        return state
    }
    
}