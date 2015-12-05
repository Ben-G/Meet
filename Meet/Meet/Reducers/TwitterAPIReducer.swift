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

    func handleAction(state: HasTwitterAPIState, action: Action) -> HasTwitterAPIState {
        switch action.type {
        case SetTwitterClient.type:
            return setTwitterClient(state, swifter: SetTwitterClient(action).twitterClient)
        case SetUserSearchResult.type:
            return setUserSearchResults(state,
                userSearchResults: SetUserSearchResult(action).userSearchResult)
        default:
            return state
        }
    }

    func setTwitterClient(var state: HasTwitterAPIState, swifter: Swifter) -> HasTwitterAPIState {
        state.twitterAPIState.swifter = swifter

        return state
    }

    func setUserSearchResults(var state: HasTwitterAPIState,
        userSearchResults: Result<[TwitterUser], TwitterAPIError>) -> HasTwitterAPIState {

        state.twitterAPIState.userSearchResults = userSearchResults

        return state
    }

}
