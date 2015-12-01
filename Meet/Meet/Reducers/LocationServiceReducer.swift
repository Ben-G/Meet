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

    func handleAction(state: HasLocationServiceState, action: LocationServiceAction) -> HasLocationServiceState {
        switch action {
        case .SetLocationServiceBusy(let busy):
            return setLocationServiceBusy(state, busy: busy)
        case .SetLocation(let location):
            return setLocation(state, location: location)
        }
    }

    func setLocationServiceBusy(var state: HasLocationServiceState, busy: Bool) -> HasLocationServiceState {
        state.locationServiceState.busyLocating = busy

        return state
    }

    func setLocation(var state: HasLocationServiceState, location: Location) -> HasLocationServiceState {
        state.locationServiceState.currentLocation = .Success(location)

        return state
    }

}
