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
    func dispatchReactive(asyncActionCreator: AsyncActionCreator) -> Signal<StateType, NoError>
    func dispatchReactive(signalAsyncActionCreator: SignalAsyncActionCreator)
        -> Signal<StateType, NoError>?

    func dispatchReactive(actionCreator: ActionCreator) -> Signal<StateType, NoError>
    func dispatchReactive(action: ActionType) -> Signal<StateType, NoError>
}

public typealias SignalAsyncActionCreator = (state: StateType, store: Store)
    -> Signal<ActionCreator, NoError>?

public class MainStoreReactiveCocoa: MainStore, ReactiveCocoaStore {

    public func dispatchReactive(action: ActionType) -> Signal<StateType, NoError> {
        return Signal { observer in
            super.dispatch(action) { newState in
                observer.sendNext(newState)
                observer.sendCompleted()
            }

            return nil
        }
    }

    public func dispatchReactive(actionCreator: ActionCreator) -> Signal<StateType, NoError> {
        return Signal { observer in
            super.dispatch(actionCreator) { newState in
                observer.sendNext(newState)
                observer.sendCompleted()
            }

            return nil
        }
    }

    public func dispatchReactive(asyncActionCreator: AsyncActionCreator)
        -> Signal<StateType, NoError> {

        return Signal { observer in
            super.dispatch(asyncActionCreator) { newState in
                observer.sendNext(newState)
                observer.sendCompleted()
            }

            return nil
        }
    }

    public func dispatchReactive(signalAsyncActionCreator: SignalAsyncActionCreator)
        -> Signal<StateType, NoError>? {

        return signalAsyncActionCreator(state: appState, store: self)?
            .flatMap(FlattenStrategy.Concat, transform: { actionCreator in
                return self.dispatchReactive(actionCreator)
            })
    }

}
