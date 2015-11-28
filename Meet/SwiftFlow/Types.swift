//
//  Types.swift
//  Meet
//
//  Created by Benjamin Encz on 11/27/15.
//  Copyright © 2015 DigiTales. All rights reserved.
//

import Foundation

public protocol ActionProtocol {}

public protocol AppStateProtocol {
    init()
}

public protocol StoreSubscriber {
    func newState(state: AppStateProtocol)
}

public protocol Reducer {
    func handleAction(state: AppStateProtocol, action: ActionProtocol) -> AppStateProtocol
}