//
//  DataMutationActionCreator.swift
//  Meet
//
//  Created by Benjamin Encz on 11/19/15.
//  Copyright © 2015 DigiTales. All rights reserved.
//

import Foundation
import SwiftFlowReactiveCocoaExtensions

struct DataMutationActionCreator {

    func createNewContact(email: String) -> ActionCreator {
        return { _ in
            return DataMutationAction.CreateContactFromEmail(email)
        }
    }
    
    func deleteContact(contactID: Int) -> ActionCreator {
        return { _ in
            return DataMutationAction.DeleteContact(contactID)
        }
    }
    
    func setContacts(contacts: [Contact]) -> ActionCreator {
        return { _ in
            return DataMutationAction.SetContacts(contacts)
        }
    }
    
}