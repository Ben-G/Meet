//
//  RecordingStore.swift
//  Meet
//
//  Created by Benjamin Encz on 12/1/15.
//  Copyright © 2015 DigiTales. All rights reserved.
//

import Foundation
import SwiftFlow
import SwiftFlowPersistenceNSCoding

public class RecordingMainStore<StoreActionType: ActionType where StoreActionType: Coding>
    : MainStore<StoreActionType> {

    override public init(reducer: AnyReducer, appState: StateType) {
        super.init(reducer: reducer, appState: appState)
    }

    public override func dispatch(action: StoreActionType, callback: DispatchCallback?) {
        super.dispatch(action, callback: callback)

        print(action.dictionaryRepresentation())
    }

}