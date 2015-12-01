//
//  CounterReducer.swift
//  Meet
//
//  Created by Benjamin Encz on 12/1/15.
//  Copyright © 2015 DigiTales. All rights reserved.
//

import Foundation
import SwiftFlow

struct CounterReducer: Reducer {

    func handleAction(var state: AppState, action: CounterAction) -> AppState {
        switch action {
        case .Increase:
            state.counter += 1
        case .Decrease:
            state.counter -= 1
        }

        return state
    }

}