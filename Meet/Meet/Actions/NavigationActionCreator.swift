//
//  NavigationActionCreator.swift
//  Meet
//
//  Created by Benji Encz on 12/31/15.
//  Copyright © 2015 DigiTales. All rights reserved.
//

import SwiftFlow
import SwiftFlowRouter

func pushRouteSegement(routeElementIdentifier: RouteElementIdentifier) -> ActionCreator {
    return { state, store in
        guard var navigationState = state as? HasNavigationState else { return nil }
        var newRoute = navigationState.navigationState.route
        newRoute.append(routeElementIdentifier)

        return SetRouteAction(newRoute)
    }
}