//
//  NavigationState.swift
//  Meet
//
//  Created by Benjamin Encz on 11/11/15.
//  Copyright © 2015 DigiTales. All rights reserved.
//

import UIKit

public typealias RouteElementIdentifier = String

public struct NavigationState {
    public init() {}

    public var route: [RouteElementIdentifier] = []
    public var subRouteState: [NSDictionary] = []
}

public protocol HasNavigationState {
    var navigationState: NavigationState { get set }
}
