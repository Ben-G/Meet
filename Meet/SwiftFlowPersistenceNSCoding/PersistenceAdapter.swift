//
//  PersistenceAdapter.swift
//  Meet
//
//  Created by Benjamin Encz on 11/24/15.
//  Copyright © 2015 DigiTales. All rights reserved.
//

import Foundation
import SwiftFlow

public protocol Persistable {
    typealias DataState

    func persistableState() -> DataState
}

public class PersistenceAdapter<DataStateType: Coding,
    AppState: Persistable where AppState.DataState == DataStateType>: StoreSubscriber {

    public init() {}

    // Need to bind store late to avoid cyclycal references
    public var store: Store? { didSet {
            store?.subscribe(self)
        }
    }

    public func hydrateStore() -> DataStateType? {
        if let path = filePath() {
            do {
                let data = NSData(contentsOfURL: path)
                if let data = data {
                    let state = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? NSDictionary
                    if let state = state {
                        return DataStateType(dictionary: state)
                    } else {
                        return nil
                    }
                }
            }
        }

        return nil
    }

    public func newState(state: AppState) {
        let dataState = state.persistableState()
        let data = NSKeyedArchiver.archivedDataWithRootObject(dataState.dictionaryRepresentation())

        if let path = filePath() {
            do {
                try data.writeToURL(path, atomically: true)
            } catch {
                /* error handling here */
            }
        }
    }

    func filePath() -> NSURL? {
        let documentDirectoryURL =
            try? NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain:
                .UserDomainMask, appropriateForURL: nil, create: true)


        return documentDirectoryURL?.URLByAppendingPathComponent("contacts")
    }

}
