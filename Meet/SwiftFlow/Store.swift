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
    func dispatch(actionCreatorProvider: ActionCreatorProvider)
    func dispatch(actionCreatorProvider: AsyncActionCreatorProvider)

    func dispatch(action: ActionProtocol, callback: DispatchCallback?)
    func dispatch(actionCreatorProvider: ActionCreatorProvider, callback: DispatchCallback?)
    func dispatch(asyncActionCreatorProvider: AsyncActionCreatorProvider, callback: DispatchCallback?)
}

public typealias DispatchCallback = (AppStateProtocol) -> Void
public typealias ActionCreator = (state: AppStateProtocol, store: Store) -> ActionProtocol?

/// AsyncActionCreators allow the developer to wait for the completion of an async action
public typealias AsyncActionCreator = (state: AppStateProtocol, store: Store, actionCreatorCallback: ActionCreator -> Void) -> Void

public typealias ActionCreatorProvider = () -> ActionCreator
public typealias AsyncActionCreatorProvider = () -> AsyncActionCreator