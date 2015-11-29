//
//  PersistenceAdapter.swift
//  Meet
//
//  Created by Benjamin Encz on 11/24/15.
//  Copyright © 2015 DigiTales. All rights reserved.
//

import Foundation
import SwiftFlow

public protocol Coding {
    init?(dictionary: NSDictionary)
    func dictionaryRepresentation() -> NSDictionary
}

public class PersistenceAdapter<DataState: Coding>: StoreSubscriber {
    
    public init() {}
    
    // Need to bind store late to avoid cyclycal references
    public var store: Store? { didSet {
            store?.subscribe(self)
        }
    }
    
    public func hydrateStore() -> DataState? {
        if let path = filePath() {
            do {
                let data = NSData(contentsOfURL: path)
                if let data = data {
                    let state = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? NSDictionary
                    if let state = state {
                        return DataState(dictionary: state)
                    } else {
                        return nil
                    }                    
                }
            }
        }
        
        return nil
    }
    
    public func newState(state: DataState) {
        let data = NSKeyedArchiver.archivedDataWithRootObject(state.dictionaryRepresentation())
    
        if let path = filePath()  {
            do {
                try data.writeToURL(path, atomically: true)
            }
            catch {/* error handling here */}
        }
    }
    
    func filePath() -> NSURL? {
        let documentDirectoryURL = try! NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: true)

        
        return documentDirectoryURL.URLByAppendingPathComponent("contacts")
    }
    
}