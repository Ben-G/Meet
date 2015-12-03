//
//  SwiftFlowRouterUnitTests.swift
//  Meet
//
//  Created by Benjamin Encz on 12/2/15.
//  Copyright © 2015 DigiTales. All rights reserved.
//

import Quick
import Nimble

import SwiftFlow
@testable import SwiftFlowRouter

class SwiftFlowRouterUnitTests: QuickSpec {

    override func spec() {
        describe("routing calls") {

            let tabBarViewControllerIdentifier = "TabBarViewController"
            let counterViewControllerIdentifier = "CounterViewController"
            let statsViewControllerIdentifier = "StatsViewController"

            it("can derive steps from an empty route to a multi segment route") {
                let oldRoute: [RouteElementIdentifier] = []
                let newRoute = [tabBarViewControllerIdentifier, statsViewControllerIdentifier]

                let routingActions = Router.deriveRoutingActionsForTransitionFrom(oldRoute,
                    newRoute: newRoute)

                var action1IsPush: Bool?
                var action2IsPush: Bool?

                if case RoutingActions.Push = routingActions[0] {
                    action1IsPush = true
                }

                if case RoutingActions.Push = routingActions[1] {
                    action2IsPush = true
                }

                expect(routingActions).to(haveCount(2))
                expect(action1IsPush).to(beTrue())
                expect(action2IsPush).to(beTrue())
            }

            it("generates a Change action on the last common subroute") {
                let oldRoute = [tabBarViewControllerIdentifier, counterViewControllerIdentifier]
                let newRoute = [tabBarViewControllerIdentifier, statsViewControllerIdentifier]

                let routingActions = Router.deriveRoutingActionsForTransitionFrom(oldRoute,
                    newRoute: newRoute)

                var controllerIndex: Int?
                var toBeReplaced: RouteElementIdentifier?
                var new: RouteElementIdentifier?

                if case let RoutingActions.Change(responsibleControllerIndex,
                    controllerToBeReplaced,
                    newController) = routingActions.first! {
                        controllerIndex = responsibleControllerIndex
                        toBeReplaced = controllerToBeReplaced
                        new = newController
                }

                expect(routingActions).to(haveCount(1))
                expect(controllerIndex).to(equal(0))
                expect(toBeReplaced).to(equal(counterViewControllerIdentifier))
                expect(new).to(equal(statsViewControllerIdentifier))
            }

        }
    }

}