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
import Result

struct TwitterAPIReducer: Reducer {
    
    func handleAction(state: HasTwitterAPIState, action: TwitterAPIAction) -> HasTwitterAPIState {
        switch action {
        case .SetTwitterClient(let swifter):
            return setTwitterClient(state, swifter: swifter)
        case .SetUserSearchResults(let result):
            return setUserSearchResults(state, userSearchResults: result)
        }
    }
        
    func setTwitterClient(var state: HasTwitterAPIState, swifter: Swifter) -> HasTwitterAPIState {
        state.twitterAPIState.swifter = swifter
        
        return state
    }
    
    func setUserSearchResults(var state: HasTwitterAPIState, userSearchResults: Result<[TwitterUser], TwitterAPIError>) -> HasTwitterAPIState {
        state.twitterAPIState.userSearchResults = userSearchResults
        
        return state
    }
    
}