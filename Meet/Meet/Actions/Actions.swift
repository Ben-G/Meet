//
//  Actions.swift
//  Meet
//
//  Created by Benjamin Encz on 11/11/15.
//  Copyright © 2015 DigiTales. All rights reserved.
//

import UIKit
import SwifteriOS
import SwiftFlow
import SwiftFlowPersistenceNSCoding

enum TwitterAPIAction: ActionType {
    case SetTwitterClient(Swifter)
    case SetUserSearchResults([TwitterUser])
}

enum DataMutationAction: ActionType, Coding {
    case CreateContactFromEmail(String)
    case DeleteContact(Int)
    case SetContacts([Contact])
    
    init?(dictionary: NSDictionary) {
        let type = dictionary["type"] as? String
        
        if (type == "CreateContactFromEmail") {
            let email = dictionary["payload"] as! String
            self = .CreateContactFromEmail(email)
        } else if (type == "DeleteContact") {
            let identifier = dictionary["payload"] as! Int
            self = .DeleteContact(identifier)
        } else if (type == "SetContacts") {
            let contacts = dictionary["payload"] as! NSArray
            let mappedContacts = contacts.map { Contact(dictionary: $0 as! NSDictionary)! }
            self = .SetContacts(mappedContacts)
        } else {
            return nil
        }
    }
    
    func dictionaryRepresentation() -> NSDictionary {
        switch self {
        case .CreateContactFromEmail(let email):
            return ["type": "CreateContactFromEmail", "payload": email]
        case .DeleteContact(let contactID):
            return ["type": "DeleteContact", "payload": contactID]
        case .SetContacts(let contacts):
            return ["type": "SetContacts", "payload": contacts.map { (contact: Contact) in contact.dictionaryRepresentation() }]
        }
    }
}