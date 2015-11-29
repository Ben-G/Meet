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

public class MainStoreReactiveCocoa: MainStore, ReactiveCocoaStore {
    
    public func dispatch(action: ActionProtocol) -> Signal<AppStateProtocol, NoError> {
        return Signal { observer in
            super.dispatch(action) { newState in
                observer.sendNext(newState)
                observer.sendCompleted()
            }
            
            return nil
        }
    }
    
    public func dispatch(actionCreatorProvider: ActionCreatorProvider) -> Signal<AppStateProtocol, NoError> {
        return Signal { observer in
            super.dispatch(actionCreatorProvider) { newState in
                observer.sendNext(newState)
                observer.sendCompleted()
            }
            
            return nil
        }
    }
    
  public func dispatch(actionCreatorProvider: AsyncActionCreatorProvider) -> Signal<AppStateProtocol, NoError> {
        return Signal { observer in
            super.dispatch(actionCreatorProvider) { newState in
                observer.sendNext(newState)
                observer.sendCompleted()
            }
            
            return nil
        }
    }
    
}

public protocol ReactiveCocoaStore {
    func dispatch(actionCreatorProvider: AsyncActionCreatorProvider) -> Signal<AppStateProtocol, NoError>
    
    func dispatch(actionCreatorProvider: ActionCreatorProvider) -> Signal<AppStateProtocol, NoError>
    func dispatch(action: ActionProtocol) -> Signal<AppStateProtocol, NoError>
}

//public typealias ActionCreator = (state: AppStateProtocol, store: Store) -> ActionProtocol?
//public typealias AsyncActionCreator = (state: AppStateProtocol, store: Store) -> Signal<ActionCreator,NoError>?
//
//public typealias ActionCreatorProvider = () -> ActionCreator
//public typealias AsyncActionCreatorProvider = () -> AsyncActionCreator
