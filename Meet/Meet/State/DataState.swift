//
//  DataState.swift
//  Meet
//
//  Created by Benjamin Encz on 11/19/15.
//  Copyright © 2015 DigiTales. All rights reserved.
//

import Foundation

struct DataState {
    var contacts: [Contact] = persistenceAdapter.hydrateStore() ?? []
}

protocol HasDataState {
    var dataState: DataState { get set }
}