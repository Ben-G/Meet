//
//  CounterActions.swift
//  Meet
//
//  Created by Benjamin Encz on 12/1/15.
//  Copyright © 2015 DigiTales. All rights reserved.
//

import Foundation
import SwiftFlow
import SwiftFlowPersistenceNSCoding

let CounterActionIncrease = "COUNTER_ACTION_INCREASE"
let CounterActionDecrease = "COUNTER_ACTION_DECREASE"

struct Action: ActionType {
    let type: String
    let payload: NSDictionary?

    init(_ type: String) {
        self.type = type
        self.payload = nil
    }
}

extension Action: Coding {

    init?(dictionary: NSDictionary) {
        self.type = dictionary["type"] as! String
        self.payload = dictionary["payload"] as? NSDictionary
    }

    func dictionaryRepresentation() -> NSDictionary {
        if let payload = payload {
            return ["type": type, "payload": payload]
        } else {
            return ["type": type, "payload": "null"]
        }
    }

}