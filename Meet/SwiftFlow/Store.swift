//
//  Store.swift
//  Meet
//
//  Created by Benjamin Encz on 11/28/15.
//  Copyright © 2015 DigiTales. All rights reserved.
//

import Foundation

public protocol Store {
    var appState: AppStateProtocol { get }
    
    func subscribe(subscriber: AnyStoreSubscriber)
    func unsubscribe(subscriber: AnyStoreSubscriber)
    
    func dispatch(action: ActionProtocol)
    func dispatch(actionCreatorProvider: ActionCreator)
    func dispatch(actionCreatorProvider: AsyncActionCreator)

    func dispatch(action: ActionProtocol, callback: DispatchCallback?)
    func dispatch(actionCreatorProvider: ActionCreator, callback: DispatchCallback?)
    func dispatch(asyncActionCreatorProvider: AsyncActionCreator, callback: DispatchCallback?)
}

public typealias DispatchCallback = (AppStateProtocol) -> Void
public typealias ActionCreator = (state: AppStateProtocol, store: Store) -> ActionProtocol?

/// AsyncActionCreators allow the developer to wait for the completion of an async action
public typealias AsyncActionCreator = (state: AppStateProtocol, store: Store, actionCreatorCallback: ActionCreator -> Void) -> Void