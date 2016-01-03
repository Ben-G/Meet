//
//  DataMutationActions.swift
//  Meet
//
//  Created by Benjamin Encz on 12/4/15.
//  Copyright © 2015 DigiTales. All rights reserved.
//

import Foundation
import SwiftFlow
import SwiftFlowRecorder

// MARK: Create Contact From Email

struct CreateContactFromEmail: Action {
    static let type = "CreateContactFromEmail"
    let email: String

    init(_ email: String) {
        self.email = email
    }
}

// MARK: Create From Twitter User

struct CreateContactWithTwitterUser: Action {
    static let type = "CreateContactWithTwitterUser"
    let twitterUser: TwitterUser

    init(_ twitterUser: TwitterUser) {
        self.twitterUser = twitterUser
    }
}

// MARK: Create From Twitter User

struct DeleteContact: Action {
    static let type = "DeleteContact"
    let contactID: Int

    init(_ contactID: Int) {
        self.contactID = contactID
    }
}

// MARK: Set Contacts

struct SetContacts: Action {
    static let type = "SetContacts"
    let contacts: [Contact]

    init(contacts: [Contact]) {
        self.contacts = contacts
    }
}

extension SetContacts: StandardActionConvertible {

    init(_ action: StandardAction) {
        self.contacts = (action.payload!["contacts"] as! [[String : AnyObject]]).map {
            return Contact(dictionary: $0)
        }
    }

    func toStandardAction() -> StandardAction {
        return StandardAction(type: SetContacts.type,
            payload: ["contacts": contacts.map { $0.dictionaryRepresentation() }],
            isTypedAction: true)
    }

}

// MARK: Serialization Code

let DataMutationActionsTypeMap: TypeMap = [
    CreateContactFromEmail.type: CreateContactFromEmail.self,
    CreateContactWithTwitterUser.type: CreateContactWithTwitterUser.self,
    DeleteContact.type: DeleteContact.self,
    SetContacts.type: SetContacts.self
]
