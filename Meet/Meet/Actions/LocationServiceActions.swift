//
//  LocationServiceActions.swift
//  Meet
//
//  Created by Benjamin Encz on 12/4/15.
//  Copyright © 2015 DigiTales. All rights reserved.
//

import Foundation
import SwiftFlow

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

extension SetLocationServiceBusy: ActionConvertible {

    init(_ action: Action) {
        self.busy = action.payload!["busy"] as! Bool
    }

    func toAction() -> Action {
        return Action(type: SetLocationServiceBusy.type, payload: ["busy": busy])
    }

}

// MARK: SetLocation

struct SetLocation {
    static let type = "SetLocationServiceBusy"
    let location: Location

    init(_ location: Location) {
        self.location = location
    }
}

extension SetLocation: ActionConvertible {

    init(_ action: Action) {
        self.location = Location(dictionary: action.payload!["location"] as! [String : AnyObject])
    }

    func toAction() -> Action {
        return Action(type: SetLocation.type,
            payload: ["location": location.dictionaryRepresentation()])
    }

}
