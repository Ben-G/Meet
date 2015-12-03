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

            beforeEach() {

            }

            it("can derive steps from an empty route to a multi segment route") {
                
            }

            it("generates a Change action on the last common subroute") {
                let oldRoute = [tabBarViewControllerIdentifier, counterViewControllerIdentifier]
                let newRoute = [tabBarViewControllerIdentifier, statsViewControllerIdentifier]

                let routingActions = Router.deriveRoutingActionsForTransitionFrom(oldRoute,
                    newRoutes: newRoute)

                var controllerIndex: Int?
                var toBeReplaced: ViewControllerIdentifier?
                var new: ViewControllerIdentifier?

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