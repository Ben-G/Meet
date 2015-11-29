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

public protocol ReactiveCocoaStore {
    func dispatchReactive(actionCreatorProvider: AsyncActionCreatorProvider) -> Signal<AppStateProtocol, NoError>
    func dispatchReactive(SignalAsyncActionCreator: SignalAsyncActionCreator) -> Signal<AppStateProtocol, NoError>?
    func dispatchReactive(actionCreatorProvider: ActionCreatorProvider) -> Signal<AppStateProtocol, NoError>
    func dispatchReactive(action: ActionProtocol) -> Signal<AppStateProtocol, NoError>
}

public typealias SignalAsyncActionCreator = (state: AppStateProtocol, store: Store) -> Signal<ActionCreator,NoError>?

public class MainStoreReactiveCocoa: MainStore, ReactiveCocoaStore {
    
    public func dispatchReactive(action: ActionProtocol) -> Signal<AppStateProtocol, NoError> {
        return Signal { observer in
            super.dispatch(action) { newState in
                observer.sendNext(newState)
                observer.sendCompleted()
            }
            
            return nil
        }
    }
    
    public func dispatchReactive(actionCreatorProvider: ActionCreatorProvider) -> Signal<AppStateProtocol, NoError> {
        return Signal { observer in
            super.dispatch(actionCreatorProvider) { newState in
                observer.sendNext(newState)
                observer.sendCompleted()
            }
            
            return nil
        }
    }
    
  public func dispatchReactive(actionCreatorProvider: AsyncActionCreatorProvider) -> Signal<AppStateProtocol, NoError> {
        return Signal { observer in
            super.dispatch(actionCreatorProvider) { newState in
                observer.sendNext(newState)
                observer.sendCompleted()
            }
            
            return nil
        }
    }
    
    public func dispatchReactive(signalAsyncActionCreator: SignalAsyncActionCreator) -> Signal<AppStateProtocol, NoError>? {
        return signalAsyncActionCreator(state: appState, store: self)?.flatMap(FlattenStrategy.Concat, transform: { actionCreator in
            return self.dispatchReactive { actionCreator }
        })
    }
    
}
