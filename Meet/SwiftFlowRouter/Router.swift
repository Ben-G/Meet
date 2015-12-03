//
//  Router.swift
//  Meet
//
//  Created by Benjamin Encz on 11/11/15.
//  Copyright © 2015 DigiTales. All rights reserved.
//

import UIKit
import SwiftFlow

// TODO: Ensure this protocol requires UIViewControlelrs
public protocol RoutableViewController {

    func pushRouteSegment(viewControllerIdentifier: ViewControllerIdentifier) -> RoutableViewController
    func popRouteSegment(viewControllerIdentifier: ViewControllerIdentifier)
    func changeRouteSegment(fromViewControllerIdentifier: ViewControllerIdentifier,
        toViewControllerIdentifier: ViewControllerIdentifier) -> RoutableViewController

}

public class Router: StoreSubscriber {

    public typealias RootViewControllerProvider = (viewControllerIdentifier: ViewControllerIdentifier) -> RoutableViewController

    var store: MainStore
    var lastNavigationState = NavigationState()
    var rootViewControllerProvider: RootViewControllerProvider
    // maps route segements to UIViewController instances
    var viewControllerForSubroute: [RoutableViewController] = []

    public init(store: MainStore, rootViewControllerProvider: RootViewControllerProvider) {
        self.store = store
        self.rootViewControllerProvider = rootViewControllerProvider

        self.store.subscribe(self)
    }

    public func newState(state: HasNavigationState) {
        let routingActions = Router.deriveRoutingActionsForTransitionFrom(
            lastNavigationState.route, newRoutes: state.navigationState.route)

        routingActions.forEach { routingAction in
            switch routingAction {

            case let .Pop(responsibleControllerIndex, controllerToBePopped):
                viewControllerForSubroute[responsibleControllerIndex].popRouteSegment(controllerToBePopped)
                viewControllerForSubroute.removeAtIndex(responsibleControllerIndex + 1)

            case let .Change(responsibleControllerIndex, controllerToBeReplaced, newController):
                viewControllerForSubroute[responsibleControllerIndex + 1] =
                    viewControllerForSubroute[responsibleControllerIndex]
                        .changeRouteSegment(controllerToBeReplaced,
                            toViewControllerIdentifier: newController)

            case let .Push(responsibleControllerIndex, controllerToBePushed):
                if responsibleControllerIndex >= 0 {
                    viewControllerForSubroute.append(
                        viewControllerForSubroute[responsibleControllerIndex]
                            .pushRouteSegment(controllerToBePushed)
                    )
                } else {
                    viewControllerForSubroute.append(
                        rootViewControllerProvider(viewControllerIdentifier: controllerToBePushed)
                    )
                }
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

            } else if (oldRouteIndex > newRouteIndex && oldRouteIndex > 0) {
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
