//
//  LocationServiceReducer.swift
//  Meet
//
//  Created by Benjamin Encz on 11/29/15.
//  Copyright © 2015 DigiTales. All rights reserved.
//

import Foundation
import SwiftFlow

struct LocationServiceReducer: Reducer {

    func handleAction(state: HasLocationServiceState, action: Action)
        -> HasLocationServiceState {
            
        switch action.type {
        case SetLocationServiceBusy.type:
            return setLocationServiceBusy(state, busy: SetLocationServiceBusy(action).busy)
        case SetLocation.type:
            return setLocation(state, location: SetLocation(action).location)
        default:
            abort()
        }
    }

    func setLocationServiceBusy(var state: HasLocationServiceState, busy: Bool)
        -> HasLocationServiceState {

        state.locationServiceState.busyLocating = busy

        return state
    }

    func setLocation(var state: HasLocationServiceState, location: Location)
        -> HasLocationServiceState {

        state.locationServiceState.currentLocation = .Success(location)

        return state
    }

}
