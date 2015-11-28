//
//  SwiftFlowTests.swift
//  SwiftFlowTests
//
//  Created by Benjamin Encz on 11/27/15.
//  Copyright © 2015 DigiTales. All rights reserved.
//

import XCTest
@testable import SwiftFlow
@testable import SwiftFlowReactiveCocoaExtensions

struct TestAppState: AppStateProtocol {
    var testValue: Int?
    
    init() {
        testValue = nil
    }
}

enum TestAction: ActionProtocol {
    case SetValue(Int)
}

struct TestReducer: Reducer {
    func handleAction(var state: TestAppState, action: TestAction) -> TestAppState {
        switch action {
        case .SetValue(let value):
            state.testValue = value
            return state
        }
    }
}

class TestStoreSubscriber: StoreSubscriber {
    var receivedState: TestAppState?
    
    func newState(state: TestAppState) {
        receivedState = state
    }
}

class StoreTests: XCTestCase {
    
    var store: Store!
    var reducer: TestReducer!
    
    override func setUp() {
        super.setUp()
        
        reducer = TestReducer()
        store = MainStore(reducer: reducer, appState: TestAppState())
    }
    
    func testDispatchesInitialValueUponSubscription() {
        let expectation = expectationWithDescription("Sets initial value")
        
        store = MainStore(reducer: reducer, appState: TestAppState())

        let subscriber = TestStoreSubscriber()
        
        store.dispatch(TestAction.SetValue(3)).observeNext { newState in
            if (subscriber.receivedState?.testValue == 3) {
                expectation.fulfill()
            }
        }
        
        store.subscribe(subscriber)
        
        waitForExpectationsWithTimeout(2.0, handler: nil)
    }
    
}
