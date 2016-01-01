//
//  RouteDataActions.swift
//  Meet
//
//  Created by Benji Encz on 12/31/15.
//  Copyright © 2015 DigiTales. All rights reserved.
//

import SwiftFlow
import SwiftFlowRouter

struct SetRouteSpecificData: Action {

    var route: [RouteElementIdentifier]
    var data: Coding

}