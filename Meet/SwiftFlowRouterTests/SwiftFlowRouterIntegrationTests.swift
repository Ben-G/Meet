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

class FakeRoutableViewController: RoutableViewController {

    func pushRouteSegment(viewControllerIdentifier: ViewControllerIdentifier) -> RoutableViewController {
        return FakeRoutableViewController()
    }

    func popRouteSegment(viewControllerIdentifier: ViewControllerIdentifier) {

    }

    func changeRouteSegment(fromViewControllerIdentifier: ViewControllerIdentifier,
        toViewControllerIdentifier: ViewControllerIdentifier) -> RoutableViewController {
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
                        ViewControllerIdentifier) -> RoutableViewController {
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

                    class FakeRootRoutable: RoutableViewController {
                        var calledWithIdentifier: ViewControllerIdentifier?

                        func pushRouteSegment(viewControllerIdentifier: ViewControllerIdentifier)
                            -> RoutableViewController {
                            calledWithIdentifier = viewControllerIdentifier

                            return FakeRoutableViewController()
                        }

                        func popRouteSegment(viewControllerIdentifier: ViewControllerIdentifier) { }

                        func changeRouteSegment(fromViewControllerIdentifier: ViewControllerIdentifier,
                            toViewControllerIdentifier: ViewControllerIdentifier) -> RoutableViewController {
                                abort()
                        }
                    }

                    let fakeRoutable = FakeRootRoutable()

                    let _ = Router(store: store) { identifier in
                        return fakeRoutable
                    }

                    // Let Run Loop Run so that dispatched actions can be performed
                    NSRunLoop.currentRunLoop().runMode(NSDefaultRunLoopMode,
                        beforeDate: NSDate.distantFuture())

                    expect(fakeRoutable.calledWithIdentifier).to(equal("SecondViewController"))
                }

            }

        }
    }
    
}
