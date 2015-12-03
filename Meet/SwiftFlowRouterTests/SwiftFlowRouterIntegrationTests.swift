//
//  SwiftFlowRouterTests.swift
//  SwiftFlowRouterTests
//
//  Created by Benjamin Encz on 12/2/15.
//  Copyright © 2015 DigiTales. All rights reserved.
//

import Quick
import Nimble

import SwiftFlow
@testable import SwiftFlowRouter

class FakeRoutableViewController: Routable {


    func pushRouteSegment(routeSegment: RouteElementIdentifier,
        completionHandler: RoutingCompletionHandler) -> Routable {
            completionHandler()
            return FakeRoutableViewController()
    }

    func popRouteSegment(routeSegment: RouteElementIdentifier,
        completionHandler: RoutingCompletionHandler) {
            completionHandler()
    }

    func changeRouteSegment(from: RouteElementIdentifier,
        to: RouteElementIdentifier,
        completionHandler: RoutingCompletionHandler) -> Routable {
            completionHandler()
            return FakeRoutableViewController()
    }

}

struct FakeAppState: StateType, HasNavigationState {
    var navigationState = NavigationState()
}

class FakeReducer: Reducer {
    func handleAction(state: FakeAppState, action: Action) -> FakeAppState {
        return state
    }
}

class SwiftFlowRouterIntegrationTests: QuickSpec {

    override func spec() {

        describe("routing calls") {

            var store: MainStore!

            beforeEach {
                store = MainStore(reducer: MainReducer([NavigationReducer()]), appState: FakeAppState())
            }

            describe("setup") {

                it("does not request the root view controller when no route is provided") {
                    var called = false

                    func provideRootViewController(viewControllerIdenifier:
                        RouteElementIdentifier) -> Routable {
                            called = true
                            return FakeRoutableViewController()
                    }

                    let _ = Router(store: store,
                        rootViewControllerProvider: provideRootViewController)

                    expect(called).to(beFalse())
                }

                it("requests the root with identifier when an initial route is provided") {
                    store.dispatch(
                        Action(
                            type: ActionSetRoute,
                            payload: ["route": ["TabBarViewController"]]
                        )
                    )

                    waitUntil(timeout: 2.0) { fullfill in
                        let _ = Router(store: store) { identifier in
                            if (identifier == "TabBarViewController") {
                                fullfill()
                            }

                            return FakeRoutableViewController()
                        }
                    }
                }

                it("calls push on the root for a route with two elements") {
                    store.dispatch(
                        Action(
                            type: ActionSetRoute,
                            payload: ["route": ["TabBarViewController", "SecondViewController"]]
                        )
                    )

                    class FakeRootRoutable: Routable {
                        var calledWithIdentifier: (RouteElementIdentifier?) -> Void

                        init(calledWithIdentifier: (RouteElementIdentifier?) -> Void) {
                            self.calledWithIdentifier = calledWithIdentifier
                        }

                        func pushRouteSegment(routeSegment: RouteElementIdentifier,
                            completionHandler: RoutingCompletionHandler) -> Routable {
                                calledWithIdentifier(routeSegment)

                                completionHandler()
                                return FakeRoutableViewController()
                        }

                        func popRouteSegment(viewControllerIdentifier: RouteElementIdentifier,
                            completionHandler: RoutingCompletionHandler) { abort() }

                        func changeRouteSegment(from: RouteElementIdentifier,
                            to: RouteElementIdentifier,
                            completionHandler: RoutingCompletionHandler) -> Routable { abort() }
                    }

                    waitUntil(timeout: 2.0) { completion in
                        let fakeRoutable = FakeRootRoutable() { identifier in
                            if identifier == "SecondViewController" {
                                completion()
                            }
                        }

                        let _ = Router(store: store) { identifier in
                            return fakeRoutable
                        }
                    }
                }

            }

        }
    }
    
}
