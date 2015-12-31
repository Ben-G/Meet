//
//  LocationServiceActions.swift
//  Meet
//
//  Created by Benjamin Encz on 12/4/15.
//  Copyright © 2015 DigiTales. All rights reserved.
//

import Foundation
import SwiftFlow
import SwiftFlowRecorder

//enum LocationServiceAction: Action {
//    case SetLocationServiceBusy(Bool)
//    case SetLocation(Location)
//}

// MARK: SetLocationServiceBusy

struct SetLocationServiceBusy {
    static let type = "SetLocationServiceBusy"
    let busy: Bool

    init(_ busy: Bool) {
        self.busy = busy
    }
}

// MARK: SetLocation

struct SetLocation {
    static let type = "SetLocation"
    let location: Location

    init(_ location: Location) {
        self.location = location
    }
}

// MARK: Serialization Code

let LocationServiceActionsTypeMap: TypeMap = [
    SetLocationServiceBusy.type: SetLocationServiceBusy.self,
    SetLocation.type: SetLocation.self
]

extension SetLocationServiceBusy: StandardActionConvertible {

    init(_ standardAction: StandardAction) {
        self.busy = standardAction.payload!["busy"] as! Bool
    }

    func toStandardAction() -> StandardAction {
        return StandardAction(type: SetLocationServiceBusy.type, payload: ["busy": busy], isTypedAction: true)
    }
    
}

extension SetLocation: StandardActionConvertible {

    init(_ standardAction: StandardAction) {
        self.location = Location(dictionary:
            standardAction.payload!["location"] as! [String : AnyObject])
    }

    func toStandardAction() -> StandardAction {
        return StandardAction(type: SetLocation.type,
            payload: ["location": location.dictionaryRepresentation()], isTypedAction: true)
    }

}
