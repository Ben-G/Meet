//
//  NavigationReducer.swift
//  Meet
//
//  Created by Benjamin Encz on 11/11/15.
//  Copyright © 2015 DigiTales. All rights reserved.
//

import UIKit
import SwiftFlow

public struct NavigationReducer: Reducer {

    public init() {}

    public func handleAction(state: HasNavigationState, action: Action) -> HasNavigationState {
        switch action.type {
        case ActionSetRoute:
            return setRoute(state, route: action.payload!["route"] as! [ViewControllerIdentifier])
        default:
            break
        }

        return state
    }

    func setRoute(var state: HasNavigationState, route: [ViewControllerIdentifier]) -> HasNavigationState {
        state.navigationState.route = route

        return state
    }

}