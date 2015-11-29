//
//  Store.swift
//  Meet
//
//  Created by Benjamin Encz on 11/28/15.
//  Copyright © 2015 DigiTales. All rights reserved.
//

import Foundation

public protocol Store {
    var appState: StateType { get }
    
    func subscribe(subscriber: AnyStoreSubscriber)
    func unsubscribe(subscriber: AnyStoreSubscriber)
    
    func dispatch(action: ActionType)
    func dispatch(actionCreatorProvider: ActionCreator)
    func dispatch(actionCreatorProvider: AsyncActionCreator)

    func dispatch(action: ActionType, callback: DispatchCallback?)
    func dispatch(actionCreatorProvider: ActionCreator, callback: DispatchCallback?)
    func dispatch(asyncActionCreatorProvider: AsyncActionCreator, callback: DispatchCallback?)
}

public typealias DispatchCallback = (StateType) -> Void
public typealias ActionCreator = (state: StateType, store: Store) -> ActionType?

/// AsyncActionCreators allow the developer to wait for the completion of an async action
public typealias AsyncActionCreator = (state: StateType, store: Store, actionCreatorCallback: ActionCreator -> Void) -> Void