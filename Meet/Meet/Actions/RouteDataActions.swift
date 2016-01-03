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
    var data: [String: AnyObject]

}

// MARK: Serialization

// need to use literal string here, since static members in generic types
// are not supported yet
let RouteDataActionsTypeMap: TypeMap = [
    "SetRouteSpecificData": SetRouteSpecificData.self
]

extension SetRouteSpecificData: StandardActionConvertible {

    static let type = "SetRouteSpecificData"

    init(_ standardAction: StandardAction) {
        self.route = standardAction.payload!["route"] as! [RouteElementIdentifier]
        self.data = standardAction.payload!["data"] as! [String: AnyObject]
    }

    func toStandardAction() -> StandardAction {
        let payload: [String: AnyObject] = [
            "route": self.route,
            "data": self.data
        ]

        return StandardAction(type: SetRouteSpecificData.type, payload: payload, isTypedAction: true)
    }

}