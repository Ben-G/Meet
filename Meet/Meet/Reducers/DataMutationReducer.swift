//
//  DataMutationReducer.swift
//  Meet
//
//  Created by Benjamin Encz on 11/19/15.
//  Copyright © 2015 DigiTales. All rights reserved.
//

import Foundation

struct DataMutationReducer {

    func createContact(var state: AppState, email: String) -> AppState {
        let newContactID = state.dataState.contacts.count + 1
        let newContact = Contact(identifier: newContactID, emailAddress: email)
        state.dataState.contacts.append(newContact)
        
        return state
    }
    
    func deleteContact(var state: AppState, identifier: Int) -> AppState {
        // TODO: remove dummy implementation
        state.dataState.contacts.removeLast()
        
        return state
    }
    
}