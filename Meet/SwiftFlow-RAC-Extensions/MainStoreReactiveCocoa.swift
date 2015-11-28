//
//  MainStoreReactiveCocoa.swift
//  Meet
//
//  Created by Benjamin Encz on 11/26/15.
//  Copyright © 2015 DigiTales. All rights reserved.
//

import Foundation
import ReactiveCocoa
import SwiftFlow

public class MainStore: Store {
    
    private (set) public var appState: AppStateProtocol {
        didSet {
            subscribers.forEach { $0.newState(appState) }
        }
    }
    
    public var reducer: Reducer
    private var subscribers: [StoreSubscriber] = []
    
    public init(reducer: Reducer, appState: AppStateProtocol) {
        self.reducer = reducer
        self.appState = appState
    }

    public func subscribe(subscriber: StoreSubscriber) {
        subscribers.append(subscriber)
        subscriber.newState(appState)
    }
    
    public func unsubscribe(subscriber: StoreSubscriber) {
        // TODO: implement `unsubscribe`
        //        if let index = subscribers.indexOf(subscriber) {
        //            subscribers.removeAtIndex(index)
        //        }
    }
    
    public func dispatch(actionCreatorProvider: ActionCreatorProvider) -> Signal<AppStateProtocol, NoError> {
        return Signal { observer in
            dispatch_async(dispatch_get_main_queue()) {
                let action = actionCreatorProvider()(state: self.appState, store: self)
                
                if let action = action {
                    self.appState = self.reducer.handleAction(self.appState, action: action)
                    observer.sendNext(self.appState)
                    observer.sendCompleted()
                }
            }
            return nil
        }
    }
    
  public func dispatch(actionCreatorProvider: AsyncActionCreatorProvider) -> Signal<AppStateProtocol, NoError> {
        // dispatch this asynchronously to make sure that all receivers receive new state
        // before state is modified
        return Signal { observer in
            dispatch_async(dispatch_get_main_queue()) {
                let actionProviderSignal = actionCreatorProvider()(state: self.appState, store: self)
                
                if let actionProviderSignal = actionProviderSignal {
                    actionProviderSignal.observeNext { actionProvider in
                        let action = actionProvider(state: self.appState, store: self)
                        if let action = action {
                            self.appState = self.reducer.handleAction(self.appState, action: action)
                            observer.sendNext(self.appState)
                            observer.sendCompleted()
                        }
                    }
                }
            }
            
            return nil
        }
    }
    
}

public protocol Store {
    var reducer: Reducer { get set }
    var appState: AppStateProtocol { get }
    
    func subscribe(subscriber: StoreSubscriber)
    func dispatch(actionCreatorProvider: AsyncActionCreatorProvider) -> Signal<AppStateProtocol, NoError>
    
    func dispatch(actionCreatorProvider: ActionCreatorProvider) -> Signal<AppStateProtocol, NoError>
}

public typealias ActionCreator = (state: AppStateProtocol, store: Store) -> ActionProtocol?
public typealias AsyncActionCreator = (state: AppStateProtocol, store: Store) -> Signal<ActionCreator,NoError>?

public typealias ActionCreatorProvider = () -> ActionCreator
public typealias AsyncActionCreatorProvider = () -> AsyncActionCreator

