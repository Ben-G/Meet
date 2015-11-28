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
        return withSpecificTypes(state, action: action) { (state: HasTwitterAPIState, action: TwitterAPIAction) in
            switch action {
            case .SetTwitterClient(let swifter):
                return setTwitterClient(state, swifter: swifter)
            case .SetUserSearchResults(let users):
                return setUserSearchResults(state, userSearchResults: users)
            }
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