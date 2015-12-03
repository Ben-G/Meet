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
        let routingActions = Router.deriveRoutingActionsForTransitionFrom(
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
                            assertionFailure("[SwiftFlowRouter]: Router is stuck waiting for a completion handler to be called. " +
                            "Ensure that you have called the completion handler in each Routable element.")
                        }
            }

        }

        lastNavigationState = state.navigationState
    }

    static func deriveRoutingActionsForTransitionFrom(oldRoute: [RouteElementIdentifier],
        newRoute: [RouteElementIdentifier]) -> [RoutingActions] {

            var routingActions: [RoutingActions] = []

            // find last common subroute
            var lastCommonSubroute = -1

            print("----OLD----")
            print(oldRoute)
            print("----NEW----")
            print(newRoute)

            if oldRoute.count > 0 && newRoute.count > 0 {
                while lastCommonSubroute + 1 < newRoute.count &&
                    lastCommonSubroute + 1 < oldRoute.count &&
                    newRoute[lastCommonSubroute + 1] == oldRoute[lastCommonSubroute + 1] {
                            lastCommonSubroute++
                }
            }

            // remove all view controllers that are in old state, beyond common subroute but aren't
            // in new state
            var oldRouteIndex = oldRoute.count - 1

            //TODO: Fix code that determines whether last Common Subroute needs to swap or pop

            while oldRouteIndex > lastCommonSubroute + 1 && oldRouteIndex >= 0 {
                let routeSegmentToPop = oldRoute[oldRouteIndex]

                let popAction = RoutingActions.Pop(
                    responsibleRoutableIndex: oldRouteIndex,
                    segmentToBePopped: routeSegmentToPop
                )

                routingActions.append(popAction)

                oldRouteIndex--
            }

            let newRouteIndex = newRoute.count - 1

            if oldRouteIndex == lastCommonSubroute + 1 && oldRouteIndex >= 0
                && oldRouteIndex <= newRouteIndex {

                let routeSegmentToPush = newRoute[oldRouteIndex]

                let changeAction = RoutingActions.Change(
                    responsibleRoutableIndex: oldRouteIndex,
                    segmentToBeReplaced: oldRoute[oldRouteIndex],
                    newSegment: routeSegmentToPush)

                routingActions.append(changeAction)

            } else if (oldRouteIndex > newRouteIndex) {
                let routeSegmentToPop = oldRoute[oldRouteIndex]

                let popAction = RoutingActions.Pop(
                    responsibleRoutableIndex: oldRouteIndex,
                    segmentToBePopped: routeSegmentToPop
                )

                routingActions.append(popAction)

                oldRouteIndex--
            }

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
