//
//  NavigationReducer.swift
//  Meet
//
//  Created by Benji Encz on 12/31/15.
//  Copyright © 2015 DigiTales. All rights reserved.
//

import SwiftFlow
import SwiftFlowRouter

struct RouteDataReducer: Reducer {

    func handleAction(var state: HasRouteSpecificState, action: Action)
        -> HasRouteSpecificState {

            switch action {
            case let action as SetRouteSpecificData:
                state.routeSpecificState[routeSpecificKey(action.route)] = action.data
                return state
            default:
                return state
            }
    }

}