//
//  DataMutationReducer.swift
//  Meet
//
//  Created by Benjamin Encz on 11/19/15.
//  Copyright © 2015 DigiTales. All rights reserved.
//

import Foundation
import SwiftFlow
import SwiftFlowReactiveCocoaExtensions

struct DataMutationReducer: Reducer {

    func handleAction(state: AppStateProtocol, action: ActionProtocol) -> AppStateProtocol {
        guard let a = action as? DataMutationAction else { return state }
        guard let s = state as? HasDataState else { return state }
        
        switch a {
            case .CreateContactFromEmail(let email):
                return createContact(s, email: email) as! AppStateProtocol
            case .DeleteContact(let identifier):
                return deleteContact(s, identifier: identifier) as! AppStateProtocol
            case .SetContacts(let contacts):
                return setContacts(s, contacts: contacts) as! AppStateProtocol
        }
    }
    
    func createContact(var state: HasDataState, email: String) -> HasDataState {
        let newContactID = state.dataState.contacts.count + 1
        let newContact = Contact(identifier: newContactID, emailAddress: email)
        state.dataState.contacts.append(newContact)
        
        return state
    }
    
    func deleteContact(var state: HasDataState, identifier: Int) -> HasDataState {
        // TODO: remove dummy implementation
        state.dataState.contacts.removeLast()
        
        return state
    }
    
    func setContacts(var state: HasDataState, contacts: [Contact]) -> HasDataState {
        state.dataState.contacts = contacts
        
        return state
    }
    
}