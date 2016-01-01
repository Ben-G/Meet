//
//  RouteDataActions.swift
//  Meet
//
//  Created by Benji Encz on 12/31/15.
//  Copyright © 2015 DigiTales. All rights reserved.
//

import SwiftFlow
import SwiftFlowRecorder
import SwiftFlowRouter

struct SetRouteSpecificData: Action {

    var route: [RouteElementIdentifier]
    var data: Coding

}

// MARK: Serialization

let RouteDataActionsTypeMap: TypeMap = [
    SetRouteSpecificData.type: SetRouteSpecificData.self
]

extension SetRouteSpecificData: StandardActionConvertible {

    static let type = "SetRouteSpecificData"

    init(_ standardAction: StandardAction) {
        self.route = standardAction.payload!["route"] as! [RouteElementIdentifier]
        self.data = standardAction.payload!["data"] as! Coding
    }

    func toStandardAction() -> StandardAction {
        let payload: [String: AnyObject] = [
            "route": self.route,
            "data": self.data as! AnyObject
        ]

        return StandardAction(type: SetRouteSpecificData.type, payload: payload, isTypedAction: true)
    }

}