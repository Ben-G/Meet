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
        Persistable, HasLocationServiceState {

    var navigationState = NavigationState()
    var dataState = persistenceAdapter.hydrateStore() ?? DataState()
    var twitterAPIState = TwitterAPIState()
    var locationServiceState = LocationServiceState()

    init() { }

    func persistableState() -> DataState {
        return dataState

    }
}

extension AppState: Coding {

    init(dictionary: [String : AnyObject]) {
        abort()
    }

    func dictionaryRepresentation() -> [String : AnyObject] {
        abort()
    }

}
