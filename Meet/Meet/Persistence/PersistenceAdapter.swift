//
//  PersistenceAdapter.swift
//  Meet
//
//  Created by Benjamin Encz on 11/24/15.
//  Copyright © 2015 DigiTales. All rights reserved.
//

import Foundation
import SwiftFlow
import SwiftFlowReactiveCocoaExtensions

class PersistenceAdapter: StoreSubscriber {
    
    // Need to bind store late to avoid cyclycal references
    var store: Store? { didSet {
            store?.subscribe(self)
        }
    }
    
    func hydrateStore() -> [Contact]? {
        if let path = filePath() {
            do {
                let data = NSData(contentsOfURL: path)
                if let data = data {
                    let array = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? NSArray
                    let contacts = array?.map { Contact(dictionary: $0 as! NSDictionary)! }
                    
                    if let contacts = contacts {
                        return contacts
                    }
                }
            }
        }
        
        return nil
    }
    
    func newState(maybeState: AppStateProtocol) {
        guard let state = maybeState as? AppState else { return }
        
        let contacts = state.dataState.contacts
        let contactList = contacts.map { $0.dictionaryRepresentation() }
        let data = NSKeyedArchiver.archivedDataWithRootObject(contactList)
    
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