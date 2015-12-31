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
import Result

struct TwitterAPIReducer: Reducer {

    func handleAction(state: HasTwitterAPIState, action: Action) -> HasTwitterAPIState {
        switch action {
        case let action as SetTwitterClient:
            return setTwitterClient(state, swifter: action.twitterClient)
        case let action as SetUserSearchResult:
            return setUserSearchResults(state,
                userSearchResults: action.userSearchResult)
        case let action as SetUserSearchText:
            return setUserSearchText(state, userSearchText: action.userSearchText)
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

    func setUserSearchText(var state: HasTwitterAPIState, userSearchText: String)
        -> HasTwitterAPIState {

        state.twitterAPIState.userSearchText = userSearchText

        return state
    }

}
