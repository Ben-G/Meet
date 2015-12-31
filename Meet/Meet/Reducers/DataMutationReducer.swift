//
//  DataMutationReducer.swift
//  Meet
//
//  Created by Benjamin Encz on 11/19/15.
//  Copyright © 2015 DigiTales. All rights reserved.
//

import Foundation
import SwiftFlow

struct DataMutationReducer: Reducer {

    func handleAction(state: HasDataState, action: Action) -> HasDataState {
        switch action {
        case let action as CreateContactFromEmail:
            return createContact(state, email: action.email)
        case let action as CreateContactWithTwitterUser:
            return createContact(state, twitterUser: action.twitterUser)
        case let action as DeleteContact:
            return deleteContact(state, identifier: action.contactID)
        case let action as SetContacts:
            return setContacts(state, contacts: action.contacts)
        default:
            return state
        }
    }

    func createContact(var state: HasDataState, email: String) -> HasDataState {
        let newContactID = state.dataState.contacts.count + 1
        let newContact = Contact(identifier: newContactID, emailAddress: email)
        state.dataState.contacts.append(newContact)

        return state
    }

    func createContact(var state: HasDataState, twitterUser: TwitterUser) -> HasDataState {
        let newContactID = state.dataState.contacts.count + 1
        let newContact = Contact(identifier: newContactID, twitterHandle: twitterUser.username)
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
