//
//  NavigationState.swift
//  Meet
//
//  Created by Benjamin Encz on 11/11/15.
//  Copyright © 2015 DigiTales. All rights reserved.
//

import UIKit
import SwiftFlow

public typealias RouteElementIdentifier = String

public struct NavigationState {
    public init() {}

    public var route: [RouteElementIdentifier] = []
    public var subRouteState: [StateType] = []
}

extension NavigationState: Coding {

    public init(dictionary: [String : AnyObject]) {
        route = dictionary["route"] as! [RouteElementIdentifier]
        subRouteState = dictionary["subRouteState"] as! [StateType]
    }

    public func dictionaryRepresentation() -> [String : AnyObject] {
        return [
            "route": route,
            "subRouteState": subRouteState.map { $0.dictionaryRepresentation() }
        ]
    }
}


public protocol HasNavigationState {
    var navigationState: NavigationState { get set }
}