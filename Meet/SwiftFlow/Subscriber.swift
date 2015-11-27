//
//  Subscriber.swift
//  Meet
//
//  Created by Benjamin Encz on 11/27/15.
//  Copyright © 2015 DigiTales. All rights reserved.
//

import Foundation

public protocol StoreSubscriber {
    typealias AppStateType
    
    func newState(state: AppStateType)
}

public final class AnyStoreSubscriber<SubscriberType>: StoreSubscriber {
    let subscriber: _AnySubscriberBoxBase<SubscriberType>
    
    init<T: StoreSubscriber where T.AppStateType == SubscriberType>(_ subscriber: T) {
        self.subscriber = _AnySubscriberBox(subscriber)
    }
    
    public func newState(state: SubscriberType) {
        subscriber.newState(state)
    }
}

class _AnySubscriberBoxBase<T>: StoreSubscriber {
    func newState(state: T) {
        fatalError()
    }
}

class _AnySubscriberBox<SubscriberType: StoreSubscriber>: _AnySubscriberBoxBase<SubscriberType.AppStateType> {
    let base: SubscriberType
    
    init(_ base: SubscriberType) {
        self.base = base
    }
    
    override func newState(state: SubscriberType.AppStateType) {
        base.newState(state)
    }
}