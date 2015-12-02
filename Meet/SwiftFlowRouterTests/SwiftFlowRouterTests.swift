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

class SwiftFlowRouterTests: QuickSpec {

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

            }

        }
    }
    
}
