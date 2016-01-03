//
//  SearchTwitterSceneState.swift
//  Meet
//
//  Created by Benji Encz on 12/31/15.
//  Copyright © 2015 DigiTales. All rights reserved.
//

import SwiftFlow
import SwiftFlowRecorder

protocol HasTwitterSceneState {
    var twitterSceneState: SearchTwitterScene.State { get set }
}

struct SearchTwitterScene {

    static let typeMap: TypeMap = [SearchTwitterScene.SetSelectedTwitterUser.type: SearchTwitterScene.SetSelectedTwitterUser.self]

    // MARK: State

    struct State {
        var selectedTwitterUser: TwitterUser?
    }

    // MARK: Actions

    struct SetSelectedTwitterUser: Action {
        var twitterUser: TwitterUser

        init(_ twitterUser: TwitterUser) {
            self.twitterUser = twitterUser
        }
    }

    // MARK: Reducer

    struct _Reducer: Reducer {

        func handleAction(var state: HasTwitterSceneState, action: Action) -> HasTwitterSceneState {
            if let action = action as? SetSelectedTwitterUser {
                state.twitterSceneState.selectedTwitterUser = action.twitterUser
                return state
            }

            return state
        }

    }

}
