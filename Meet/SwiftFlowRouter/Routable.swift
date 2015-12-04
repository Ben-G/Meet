//
//  Routable.swift
//  Meet
//
//  Created by Benjamin Encz on 12/3/15.
//  Copyright © 2015 DigiTales. All rights reserved.
//

import Foundation

public typealias RoutingCompletionHandler = () -> Void

public protocol Routable: RoutablePush, RoutablePop, RoutableChange {}

public protocol RoutableChange {
    func changeRouteSegment(from: RouteElementIdentifier,
        to: RouteElementIdentifier,
        completionHandler: RoutingCompletionHandler) -> Routable
}

public protocol RoutablePush {
    func pushRouteSegment(routeElementIdentifier: RouteElementIdentifier,
        completionHandler: RoutingCompletionHandler) -> Routable
}

public protocol RoutablePop {
    func popRouteSegment(routeElementIdentifier: RouteElementIdentifier,
        completionHandler: RoutingCompletionHandler)
}

public protocol RoutablePushOnly: Routable {}

extension RoutablePushOnly {
    public func changeRouteSegment(from: RouteElementIdentifier,
        to: RouteElementIdentifier, completionHandler: RoutingCompletionHandler) -> Routable {
            fatalError("This routable cannot change segments. You have not implemented it.")
    }

    public func popRouteSegment(routeElementIdentifier: RouteElementIdentifier,
        completionHandler: RoutingCompletionHandler) {
            fatalError("This routable cannot change segments. You have not implemented it.")
    }
}
