//
//  Types.swift
//  Meet
//
//  Created by Benjamin Encz on 11/27/15.
//  Copyright © 2015 DigiTales. All rights reserved.
//

import Foundation

public struct Action {
    public let type: String
    public let payload: NSDictionary?

    public init(_ type: String) {
        self.type = type
        self.payload = nil
    }

    public init(type: String, payload: NSDictionary) {
        self.type = type
        self.payload = payload
    }
}

extension Action: Coding {

    public init?(dictionary: NSDictionary) {
        self.type = dictionary["type"] as! String
        self.payload = dictionary["payload"] as? NSDictionary
    }

    public func dictionaryRepresentation() -> NSDictionary {
        if let payload = payload {
            return ["type": type, "payload": payload]
        } else {
            return ["type": type, "payload": "null"]
        }
    }
    
}

public protocol StateType {
    init()
}

public protocol SubStateType {}

public protocol AnyStoreSubscriber: class {
    func _newState(state: StateType)
}

public protocol AnyReducer {
    func _handleAction(state: StateType, action: Action) -> StateType
}

public protocol Coding {
    init?(dictionary: NSDictionary)
    func dictionaryRepresentation() -> NSDictionary
}