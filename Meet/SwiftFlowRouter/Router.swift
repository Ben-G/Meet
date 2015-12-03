//
//  Router.swift
//  Meet
//
//  Created by Benjamin Encz on 11/11/15.
//  Copyright © 2015 DigiTales. All rights reserved.
//

import UIKit
import SwiftFlow

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

public class Router: StoreSubscriber {

    var store: MainStore
    var lastNavigationState = NavigationState()

    // maps route segements to responsible Routable instances
    var routableForSubroute: [Routable] = []

    let waitForRoutingCompletionQueue = dispatch_queue_create("WaitForRoutingCompletionQueue", nil)

    public init(store: MainStore, rootRoutable: Routable) {
        self.store = store
        self.routableForSubroute.append(rootRoutable)

        self.store.subscribe(self)
    }

    public func newState(state: HasNavigationState) {
        let routingActions = Router.routingActionsForTransitionFrom(
            lastNavigationState.route, newRoute: state.navigationState.route)

        routingActions.forEach { routingAction in

            let semaphore = dispatch_semaphore_create(0)

            dispatch_async(waitForRoutingCompletionQueue) {
                switch routingAction {

                case let .Pop(responsibleRoutableIndex, segmentToBePopped):
                    dispatch_async(dispatch_get_main_queue()) {
                        self.routableForSubroute[responsibleRoutableIndex]
                            .popRouteSegment(segmentToBePopped) {
                            dispatch_semaphore_signal(semaphore)
                        }

                        self.routableForSubroute.removeAtIndex(responsibleRoutableIndex + 1)
                    }

                case let .Change(responsibleRoutableIndex, segmentToBeReplaced, newSegment):
                    dispatch_async(dispatch_get_main_queue()) {
                        self.routableForSubroute[responsibleRoutableIndex + 1] =
                            self.routableForSubroute[responsibleRoutableIndex]
                                .changeRouteSegment(segmentToBeReplaced,
                                    to: newSegment) {
                                        dispatch_semaphore_signal(semaphore)
                        }
                    }

                case let .Push(responsibleRoutableIndex, segmentToBePushed):
                    dispatch_async(dispatch_get_main_queue()) {
                        self.routableForSubroute.append(
                            self.routableForSubroute[responsibleRoutableIndex]
                                .pushRouteSegment(segmentToBePushed) {
                                    dispatch_semaphore_signal(semaphore)
                            }
                        )
                    }
                }

                let waitUntil = dispatch_time(DISPATCH_TIME_NOW, Int64(3 * Double(NSEC_PER_SEC)))

                let result = dispatch_semaphore_wait(semaphore, waitUntil)

                if result != 0 {
                    assertionFailure("[SwiftFlowRouter]: Router is stuck waiting for a completion " +
                        " handler to be called. Ensure that you have called the completion" +
                        " handler in each Routable element.")
                }
            }

        }

        lastNavigationState = state.navigationState
    }

    static func largestCommonSubroute(oldRoute: [RouteElementIdentifier],
        newRoute: [RouteElementIdentifier]) -> Int {

            var largestCommonSubroute = -1

            while largestCommonSubroute + 1 < newRoute.count &&
                  largestCommonSubroute + 1 < oldRoute.count &&
                  newRoute[largestCommonSubroute + 1] == oldRoute[largestCommonSubroute + 1] {
                    largestCommonSubroute++
            }

            return largestCommonSubroute
    }

    static func routingActionsForTransitionFrom(oldRoute: [RouteElementIdentifier],
        newRoute: [RouteElementIdentifier]) -> [RoutingActions] {

            var routingActions: [RoutingActions] = []

            print("----OLD----")
            print(oldRoute)
            print("----NEW----")
            print(newRoute)

            // Find the last common subroute between two routes
            let commonSubroute = largestCommonSubroute(oldRoute, newRoute: newRoute)

            // remove all view controllers that are in old state, beyond common subroute but aren't
            // in new state
            var oldRouteIndex = oldRoute.count - 1

            // Pop all route segments of the old route that are no longer in the new route
            // Stop one element ahead of the commonSubroute. When we are one element ahead of the
            // commmon subroute we have two options:
            //
            // 1. The old route had an element after the commonSubroute and the new route does not
            //    we need to pop the route segment after the commonSubroute
            // 2. The new route has a different element after the commonSubroute, we need to replace
            //    the old route element with the new one
            while oldRouteIndex > commonSubroute + 1 {
                let routeSegmentToPop = oldRoute[oldRouteIndex]

                let popAction = RoutingActions.Pop(
                    responsibleRoutableIndex: oldRouteIndex,
                    segmentToBePopped: routeSegmentToPop
                )

                routingActions.append(popAction)

                oldRouteIndex--
            }

            if (oldRoute.count > newRoute.count) {
                let routeSegmentToPop = oldRoute[oldRouteIndex]

                let popAction = RoutingActions.Pop(
                    responsibleRoutableIndex: oldRouteIndex,
                    segmentToBePopped: routeSegmentToPop
                )

                oldRouteIndex--
                routingActions.append(popAction)
            } else if oldRoute.count > 0 && newRoute.count > 0 {
                let routeSegmentToPush = newRoute[commonSubroute + 1]

                let changeAction = RoutingActions.Change(
                    responsibleRoutableIndex: commonSubroute + 1,
                    segmentToBeReplaced: oldRoute[commonSubroute + 1],
                    newSegment: routeSegmentToPush)

                routingActions.append(changeAction)
            }

            let newRouteIndex = newRoute.count - 1

            // push remainder of new route
            while oldRouteIndex < newRouteIndex {
                let routeSegmentToPush = newRoute[oldRouteIndex + 1]

                let pushAction = RoutingActions.Push(
                    responsibleRoutableIndex: oldRouteIndex + 1,
                    segmentToBePushed: routeSegmentToPush
                )

                routingActions.append(pushAction)

                oldRouteIndex++
            }

            return routingActions
    }

}

enum RoutingActions {
    case Push(responsibleRoutableIndex: Int, segmentToBePushed: RouteElementIdentifier)
    case Pop(responsibleRoutableIndex: Int, segmentToBePopped: RouteElementIdentifier)
    case Change(responsibleRoutableIndex: Int, segmentToBeReplaced: RouteElementIdentifier,
                    newSegment: RouteElementIdentifier)
}
