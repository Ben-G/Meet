//
//  AppState.swift
//  Meet
//
//  Created by Benjamin Encz on 11/11/15.
//  Copyright © 2015 DigiTales. All rights reserved.
//

import Foundation
import SwiftFlow
import SwiftFlowRouter
import SwiftFlowReactiveCocoaExtensions

struct AppState: StateType, HasNavigationState, HasDataState, HasTwitterAPIState {
    var navigationState = NavigationState()
    var dataState = DataState()
    var twitterAPIState = TwitterAPIState()
}