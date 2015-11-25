//
//  PersistenceAdapter.swift
//  Meet
//
//  Created by Benjamin Encz on 11/24/15.
//  Copyright © 2015 DigiTales. All rights reserved.
//

import Foundation

class PersistenceAdapter: StoreSubscriber {
    
    let store: Store
    var dataMutationActionCreator = DataMutationActionCreator()
    
    init(store: Store) {
        self.store = store
        hydrateStore()
        self.store.subscribe(self)
    }
    
    func hydrateStore() {
        if let path = filePath() {
            do {
                let data = NSData(contentsOfURL: path)
                if let data = data {
                    let array = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? NSArray
                    let contacts = array?.map { Contact(dictionary: $0 as! NSDictionary)! }
                    
                    if let contacts = contacts {
                        store.dispatch { self.dataMutationActionCreator.setContacts(contacts) }
                    }
                }
            }
            catch {/* error handling here */}
        }
    }
    
    func newState(state: AppState) {
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