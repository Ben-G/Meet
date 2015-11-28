//
//  DataMutationActionCreator.swift
//  Meet
//
//  Created by Benjamin Encz on 11/19/15.
//  Copyright © 2015 DigiTales. All rights reserved.
//

import Foundation
import SwiftFlow
import SwiftFlowReactiveCocoaExtensions

struct DataMutationActionCreator {
    
    typealias ActionCreator = (state: AppState, store: AnyStore<AppState>) -> Action?

    func createNewContact(email: String) -> ActionCreator {
        return { _ in
            return .CreateContactFromEmail(email)
        }
    }
    
    func deleteContact(contactID: Int) -> ActionCreator {
        return { _ in
            return .DeleteContact(contactID)
        }
    }
    
    func setContacts(contacts: [Contact]) -> ActionCreator {
        return { _ in
            return .SetContacts(contacts)
        }
    }
    
}