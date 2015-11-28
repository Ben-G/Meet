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
        return withSpecificTypes(state, action: action) { (state: HasDataState, action: DataMutationAction) in
            switch action {
            case .CreateContactFromEmail(let email):
                return createContact(state, email: email)
            case .DeleteContact(let identifier):
                return deleteContact(state, identifier: identifier)
            case .SetContacts(let contacts):
                return setContacts(state, contacts: contacts)
            }
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