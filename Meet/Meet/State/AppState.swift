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

struct AppState: StateType, HasNavigationState, HasDataState, HasTwitterAPIState,
        Persistable, HasLocationServiceState, HasRouteSpecificState, HasTwitterSceneState {

    var navigationState = NavigationState()
    var routeSpecificState: [String: Any] = [:]
    var dataState = persistenceAdapter.hydrateStore() ?? DataState()
    var twitterAPIState = TwitterAPIState()
    var locationServiceState = LocationServiceState()
    var twitterSceneState = SearchTwitterScene.State()

    init() { }

    func persistableState() -> DataState {
        return dataState

    }
}

// NOTE: once proven the following concepts will likely be moved into Router

protocol HasRouteSpecificState {
    var routeSpecificState: [String: Any] { get set }
}

typealias Route = [RouteElementIdentifier]

func routeSpecificKey(route: Route) -> String {
    return route.joinWithSeparator("|")
}
