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

// TODO: Ensure this protocol requires UIViewControlelrs
public protocol RoutableViewController {

    func pushRouteSegment(viewControllerIdentifier: ViewControllerIdentifier,
        completionHandler: RoutingCompletionHandler) -> RoutableViewController

    func popRouteSegment(viewControllerIdentifier: ViewControllerIdentifier,
        completionHandler: RoutingCompletionHandler)

    func changeRouteSegment(fromViewControllerIdentifier: ViewControllerIdentifier,
        toViewControllerIdentifier: ViewControllerIdentifier,
        completionHandler: RoutingCompletionHandler) -> RoutableViewController

}

public class Router: StoreSubscriber {

    public typealias RootViewControllerProvider =
        (viewControllerIdentifier: ViewControllerIdentifier) -> RoutableViewController

    var store: MainStore
    var lastNavigationState = NavigationState()
    var rootViewControllerProvider: RootViewControllerProvider
    // maps route segements to UIViewController instances
    var viewControllerForSubroute: [RoutableViewController] = []

    let waitForRoutingCompletionQueue = dispatch_queue_create("WaitForRoutingCompletionQueue", nil)

    public init(store: MainStore, rootViewControllerProvider: RootViewControllerProvider) {
        self.store = store
        self.rootViewControllerProvider = rootViewControllerProvider

        self.store.subscribe(self)
    }

    public func newState(state: HasNavigationState) {
        let routingActions = Router.deriveRoutingActionsForTransitionFrom(
            lastNavigationState.route, newRoutes: state.navigationState.route)

        routingActions.forEach { routingAction in

            let semaphore = dispatch_semaphore_create(0)

            dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)) {
                switch routingAction {

                case let .Pop(responsibleControllerIndex, controllerToBePopped):
                    dispatch_async(dispatch_get_main_queue()) {
                        if responsibleControllerIndex >= 0 {
                            self.viewControllerForSubroute[responsibleControllerIndex]
                                .popRouteSegment(controllerToBePopped) {
                                dispatch_semaphore_signal(semaphore)
                            }

                            self.viewControllerForSubroute.removeAtIndex(responsibleControllerIndex + 1)
                        } else {
                            // root case
                            self.viewControllerForSubroute.removeAtIndex(responsibleControllerIndex + 1)
                            dispatch_semaphore_signal(semaphore)
                        }
                    }

                case let .Change(responsibleControllerIndex, controllerToBeReplaced, newController):
                    dispatch_async(dispatch_get_main_queue()) {
                        self.viewControllerForSubroute[responsibleControllerIndex + 1] =
                            self.viewControllerForSubroute[responsibleControllerIndex]
                                .changeRouteSegment(controllerToBeReplaced,
                                    toViewControllerIdentifier: newController) {
                                        dispatch_semaphore_signal(semaphore)
                        }
                    }

                case let .Push(responsibleControllerIndex, controllerToBePushed):
                    if responsibleControllerIndex >= 0 {
                        dispatch_async(dispatch_get_main_queue()) {
                            self.viewControllerForSubroute.append(
                                self.viewControllerForSubroute[responsibleControllerIndex]
                                    .pushRouteSegment(controllerToBePushed) {
                                        dispatch_semaphore_signal(semaphore)
                                }
                            )
                        }
                    } else {
                        dispatch_async(dispatch_get_main_queue()) {
                            self.viewControllerForSubroute.append(
                                self.rootViewControllerProvider(viewControllerIdentifier: controllerToBePushed)
                            )
                            
                            dispatch_semaphore_signal(semaphore)
                        }
                    }
                }

                dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
            }

        }

        lastNavigationState = state.navigationState
    }

    static func deriveRoutingActionsForTransitionFrom(oldRoutes: [ViewControllerIdentifier],
        newRoutes: [ViewControllerIdentifier]) -> [RoutingActions] {

            var routingActions: [RoutingActions] = []

            // find last common subroute
            var lastCommonSubroute = -1

            print("----OLD----")
            print(oldRoutes)
            print("----NEW----")
            print(newRoutes)

            if oldRoutes.count > 0 && newRoutes.count > 0 {
                while lastCommonSubroute + 1 < newRoutes.count &&
                    lastCommonSubroute + 1 < oldRoutes.count &&
                    newRoutes[lastCommonSubroute + 1] == oldRoutes[lastCommonSubroute + 1] {
                            lastCommonSubroute++
                }
            }

            // remove all view controllers that are in old state, beyond common subroute but aren't
            // in new state
            var oldRouteIndex = oldRoutes.count - 1

            //TODO: Fix code that determines whether last Common Subroute needs to swap or pop

            while oldRouteIndex > lastCommonSubroute + 1 && oldRouteIndex >= 0 {
                let routeSegmentToPop = oldRoutes[oldRouteIndex]

                let popAction = RoutingActions.Pop(
                    responsibleControllerIndex: oldRouteIndex - 1,
                    controllerToBePopped: routeSegmentToPop
                )

                routingActions.append(popAction)

                oldRouteIndex--
            }

            let newRouteIndex = newRoutes.count - 1

            if oldRouteIndex == lastCommonSubroute + 1 && oldRouteIndex >= 0
                && oldRouteIndex <= newRouteIndex {

                let routeSegmentToPush = newRoutes[oldRouteIndex]

                let changeAction = RoutingActions.Change(
                    responsibleControllerIndex: oldRouteIndex - 1,
                    controllerToBeReplaced: oldRoutes[oldRouteIndex],
                    newController: routeSegmentToPush)

                routingActions.append(changeAction)

            } else if (oldRouteIndex > newRouteIndex) {
                let routeSegmentToPop = oldRoutes[oldRouteIndex]

                let popAction = RoutingActions.Pop(
                    responsibleControllerIndex: oldRouteIndex - 1,
                    controllerToBePopped: routeSegmentToPop
                )

                routingActions.append(popAction)

                oldRouteIndex--
            }

            // push remainder of new route
            while oldRouteIndex < newRouteIndex {
                let routeSegmentToPush = newRoutes[oldRouteIndex + 1]

                let pushAction = RoutingActions.Push(
                    responsibleControllerIndex: oldRouteIndex,
                    controllerToBePushed: routeSegmentToPush
                )

                routingActions.append(pushAction)

                oldRouteIndex++
            }

            return routingActions
    }

}

enum RoutingActions {
    case Push(responsibleControllerIndex: Int, controllerToBePushed: ViewControllerIdentifier)
    case Pop(responsibleControllerIndex: Int, controllerToBePopped: ViewControllerIdentifier)
    case Change(responsibleControllerIndex: Int, controllerToBeReplaced: ViewControllerIdentifier,
                    newController: ViewControllerIdentifier)
}
